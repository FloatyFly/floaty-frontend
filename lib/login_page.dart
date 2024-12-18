import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:floaty_client/api.dart';
import 'constants.dart';
import 'main.dart';
import 'model.dart';
import 'register_page.dart';
import 'validator.dart';
import 'ui_components.dart';
import 'package:cookie_jar/cookie_jar.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userNameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _focusUserName = FocusNode();
  final _focusPassword = FocusNode();
  bool _isProcessing = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final cookieJar = Provider.of<CookieJar>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background
          const FloatyBackgroundWidget(),
          // Login Form
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Username Field
                    TextFormField(
                      controller: _userNameTextController,
                      focusNode: _focusUserName,
                      decoration: InputDecoration(
                        hintText: "Username",
                        prefixIcon: Icon(Icons.person, color: Colors.grey),
                      ),
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 14.0),
                    // Password Field
                    TextFormField(
                      controller: _passwordTextController,
                      focusNode: _focusPassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: Icon(Icons.lock, color: Colors.grey),
                      ),
                      style: TextStyle(color: Colors.black),
                      validator: (value) =>
                          Validator.validatePassword(password: value),
                    ),
                    SizedBox(height: 16.0),
                    // Error Message
                    if (_errorMessage != null)
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    SizedBox(height: 32.0),
                    // Login Button - Wrap it in a SizedBox to match input field width
                    _isProcessing
                        ? CircularProgressIndicator()
                        : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          _focusUserName.unfocus();
                          _focusPassword.unfocus();

                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isProcessing = true;
                              _errorMessage = null;
                            });

                            try {
                              final user = await loginAndExtractSessionCookie(
                                _userNameTextController.text,
                                _passwordTextController.text,
                                cookieJar,
                              );

                              setState(() {
                                _isProcessing = false;
                              });

                              if (user != null) {
                                var floatyUser = FloatyUser.fromUserDto(user);
                                Provider.of<AppState>(context,
                                    listen: false)
                                    .login(floatyUser);

                                Navigator.pushNamed(context, FLIGHTS_ROUTE, arguments: floatyUser);
                              }
                            } catch (e) {
                              setState(() {
                                _isProcessing = false;
                                _errorMessage =
                                'Login failed. Please try again.';
                              });
                            }
                          }
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32.0),
                    // Forgot Password and Register Links
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, FORGOT_PASSWORD_ROUTE);
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          " | ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, REGISTER_ROUTE);
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<User?> loginAndExtractSessionCookie(String username, String password, CookieJar cookieJar) async {
  // Set up the needed api clients
  final apiClient = ApiClient(basePath: BASE_URL);
  final authApi = AuthApi(apiClient);

  // Make the login call
  final loginRequest = LoginRequest(name: username, password: password);
  final response = await authApi.loginUserWithHttpInfo(loginRequest);
  if (response.statusCode >= 400) {
    throw ApiException(response.statusCode, await _decodeBodyBytes(response));
  }

  // Extract the session cookie from the `Set-Cookie` header
  final setCookieHeader = response.headers['set-cookie'];
  if (setCookieHeader != null) {
    final uri = Uri.parse(BASE_URL);
    cookieJar.saveFromResponse(uri, [Cookie.fromSetCookieValue(setCookieHeader)]);
  }

  // Deserialize the body into a User object, just like the original method
  if (response.body.isNotEmpty && response.statusCode != 204) {
    return await apiClient.deserializeAsync(
      await _decodeBodyBytes(response),
      'User',
    ) as User;
  }

  return null;
}

/// Returns the decoded body as UTF-8 if the given headers indicate an 'application/json'
/// content type. Otherwise, returns the decoded body as decoded by dart:http package.
Future<String> _decodeBodyBytes(Response response) async {
  final contentType = response.headers['content-type'];
  return contentType != null && contentType.toLowerCase().startsWith('application/json')
      ? response.bodyBytes.isEmpty ? '' : utf8.decode(response.bodyBytes)
      : response.body;
}