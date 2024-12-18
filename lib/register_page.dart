import 'package:flutter/material.dart';
import 'package:floaty_client/api.dart';
import 'constants.dart';
import 'validator.dart';
import 'ui_components.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _userNameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _focusUserName = FocusNode();
  final _focusEmail = FocusNode();
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
          // Register Form
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
                    // Email Field
                    TextFormField(
                      controller: _emailTextController,
                      focusNode: _focusEmail,
                      decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email, color: Colors.grey),
                      ),
                      style: TextStyle(color: Colors.black),
                      validator: (value) => Validator.validateEmail(email: value),
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
                      validator: (value) => Validator.validatePassword(password: value),
                    ),
                    SizedBox(height: 16.0),
                    // Error Message
                    if (_errorMessage != null)
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    SizedBox(height: 32.0),
                    // Register Button - Wrap it in a SizedBox to match input field width
                    _isProcessing
                        ? CircularProgressIndicator()
                        : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          _focusUserName.unfocus();
                          _focusEmail.unfocus();
                          _focusPassword.unfocus();

                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isProcessing = true;
                              _errorMessage = null;
                            });

                            try {
                              await registerUser(
                                _userNameTextController.text,
                                _emailTextController.text,
                                _passwordTextController.text,
                              );

                              setState(() {
                                _isProcessing = false;
                              });

                              Navigator.pushNamed(context, LOGIN_ROUTE);
                            } catch (e) {
                              setState(() {
                                _isProcessing = false;
                                _errorMessage =
                                'Registration failed. Please try again.';
                              });
                            }
                          }
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32.0),
                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, LOGIN_ROUTE);
                          },
                          child: Text(
                            "Login",
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

Future<User?> registerUser(String username, String email, String password) async {
  final apiClient = ApiClient(basePath: BASE_URL);
  final authApi = AuthApi(apiClient);

  // Create a registration request
  final registerRequest = RegisterRequest(
    username: username,
    email: email,
    password: password,
  );

  return await authApi.registerUser(registerRequest);
}

