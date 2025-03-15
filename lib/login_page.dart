import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:floaty_client/api.dart';
import 'constants.dart';
import 'main.dart';
import 'model.dart';
import 'validator.dart';
import 'ui_components.dart';
import 'package:cookie_jar/cookie_jar.dart';


class LoginForm extends StatefulWidget {
  final Function(String username, String password) onSubmit;
  final String? errorMessage;
  final bool isProcessing;

  const LoginForm({
    Key? key,
    required this.onSubmit,
    this.errorMessage,
    this.isProcessing = false,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _userNameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _focusUserName = FocusNode();
  final _focusPassword = FocusNode();

  @override
  void initState() {
    super.initState();
    // Set focus on the username field when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusUserName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Username Field
          TextFormField(
            controller: _userNameTextController,
            focusNode: _focusUserName,
            decoration: const InputDecoration(
              hintText: "Username",
              prefixIcon: Icon(Icons.person, color: Colors.grey),
            ),
            style: const TextStyle(color: Colors.black),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
            textInputAction: TextInputAction.next, // Move to next field on enter
            onFieldSubmitted: (_) {
              // When 'Enter' is pressed, focus on password field
              FocusScope.of(context).requestFocus(_focusPassword);
            },
          ),
          const SizedBox(height: 14.0),
          // Password Field
          TextFormField(
            controller: _passwordTextController,
            focusNode: _focusPassword,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: "Password",
              prefixIcon: Icon(Icons.lock, color: Colors.grey),
            ),
            style: const TextStyle(color: Colors.black),
            validator: (value) => Validator.validatePassword(password: value),
            textInputAction: TextInputAction.done, // Done action on password field
            onFieldSubmitted: (_) {
              // When 'Enter' is pressed on the password field, submit the form
              _submitForm();
            },
          ),
          const SizedBox(height: 16.0),
          // Error Message
          if (widget.errorMessage != null)
            Text(
              widget.errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          const SizedBox(height: 32.0),
          // Login Button
          widget.isProcessing
              ? const CircularProgressIndicator()
              : SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _focusUserName.unfocus();
                  _focusPassword.unfocus();
                  widget.onSubmit(
                    _userNameTextController.text,
                    _passwordTextController.text,
                  );
                }
              },
              child: const Text(
                'Login',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32.0),
          // Forgot Password and Register Links
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, FORGOT_PASSWORD_ROUTE);
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
              ),
              const Text(
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
                child: const Text(
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
    );
  }

  // Submit form when 'Enter' is pressed
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _focusUserName.unfocus();
      _focusPassword.unfocus();
      widget.onSubmit(
        _userNameTextController.text,
        _passwordTextController.text,
      );
    }
  }
}


/// Login Page
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
          // AuthContainer with LoginForm
          Header(),
          AuthContainer(
            headerText: "Login",
            child: LoginForm(
              isProcessing: _isProcessing,
              errorMessage: _errorMessage,
              onSubmit: (username, password) async {
                setState(() {
                  _isProcessing = true;
                  _errorMessage = null;
                });

                try {
                  final user = await loginAndExtractSessionCookie(
                    username,
                    password,
                    cookieJar,
                  );

                  setState(() {
                    _isProcessing = false;
                  });

                  if (user != null) {
                    var floatyUser = FloatyUser.fromUserDto(user);

                    Provider.of<AppState>(context, listen: false).login(floatyUser);

                    Navigator.pushNamed(context, FLIGHTS_ROUTE);
                  }
                } on EmailNotVerifiedException {
                  setState(() {
                    _isProcessing = false;
                  });

                  Navigator.pushNamed(
                    context,
                    EMAIL_VERIFICATION_ROUTE,
                    arguments: username,
                  );
                } catch (e) {
                  setState(() {
                    _isProcessing = false;
                    _errorMessage = 'Login failed. Please try again.';
                  });
                }
              },
            ),
          ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Footer()
        ),
        ],
      ),
    );
  }
}

/// Login logic helper
Future<User?> loginAndExtractSessionCookie(
    String username, String password, CookieJar cookieJar) async {
  final apiClient = ApiClient(basePath: backendUrl);
  final authApi = AuthApi(apiClient);

  final loginRequest = LoginRequest(name: username, password: password);
  final response = await authApi.loginUserWithHttpInfo(loginRequest);

  if (response.statusCode == 401) {
    final responseBody = await _decodeBodyBytes(response);
    if (responseBody == "Email for user is not verified yet.") {
      throw EmailNotVerifiedException();
    }
    throw ApiException(response.statusCode, responseBody);
  }

  if (response.statusCode >= 400) {
    throw ApiException(response.statusCode, await _decodeBodyBytes(response));
  }

  final setCookieHeader = response.headers['set-cookie'];
  if (setCookieHeader != null) {
    final uri = Uri.parse(backendUrl);
    cookieJar.saveFromResponse(uri, [Cookie.fromSetCookieValue(setCookieHeader)]);
  }

  if (response.body.isNotEmpty && response.statusCode != 204) {
    return await apiClient.deserializeAsync(
      await _decodeBodyBytes(response),
      'User',
    ) as User;
  }

  return null;
}

Future<String> _decodeBodyBytes(Response response) async {
  final contentType = response.headers['content-type'];
  return contentType != null && contentType.toLowerCase().startsWith('application/json')
      ? response.bodyBytes.isEmpty
      ? ''
      : utf8.decode(response.bodyBytes)
      : response.body;
}

class EmailNotVerifiedException implements Exception {}
