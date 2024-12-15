import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:floaty_client/api.dart';
import 'constants.dart';
import 'main.dart';
import 'model.dart';
import 'register_page.dart';
import 'validator.dart';
import 'ui_components.dart';

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
                              final apiClient =
                              ApiClient(basePath: BASE_URL);
                              final loginRequest = LoginRequest(
                                name: _userNameTextController.text,
                                password: _passwordTextController.text,
                              );
                              final authApi = AuthApi(apiClient);

                              final user = await authApi.loginUser(loginRequest);

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