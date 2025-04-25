import 'package:flutter/material.dart';
import 'package:floaty_client/api.dart';
import 'package:floaty_client/api.dart' show UserDto;
import 'constants.dart';
import 'validator.dart';
import 'ui_components.dart';
import 'package:provider/provider.dart';
import 'package:floaty/main.dart';
import 'package:floaty/CookieAuth.dart';
import 'package:floaty/user_service.dart';
import 'package:floaty/model.dart';
import 'package:cookie_jar/cookie_jar.dart';

/// Register Form Widget
class RegisterForm extends StatefulWidget {
  final Function(String username, String email, String password) onSubmit;
  final String? errorMessage;
  final bool isProcessing;

  const RegisterForm({
    Key? key,
    required this.onSubmit,
    this.errorMessage,
    this.isProcessing = false,
  }) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _userNameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _focusUserName = FocusNode();
  final _focusEmail = FocusNode();
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
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_focusEmail);
            },
          ),
          const SizedBox(height: 14.0),
          // Email Field
          TextFormField(
            controller: _emailTextController,
            focusNode: _focusEmail,
            decoration: const InputDecoration(
              hintText: "Email",
              prefixIcon: Icon(Icons.email, color: Colors.grey),
            ),
            style: const TextStyle(color: Colors.black),
            validator: (value) => Validator.validateEmail(email: value),
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
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
            textInputAction:
                TextInputAction.done, // Done action on password field
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
          // Register Button
          widget.isProcessing
              ? const CircularProgressIndicator()
              : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _focusUserName.unfocus();
                      _focusEmail.unfocus();
                      _focusPassword.unfocus();
                      widget.onSubmit(
                        _userNameTextController.text,
                        _emailTextController.text,
                        _passwordTextController.text,
                      );
                    }
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
          const SizedBox(height: 32.0),
          // Login Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an account? ",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, LOGIN_ROUTE);
                },
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.blue, fontSize: 14),
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
      _focusEmail.unfocus();
      _focusPassword.unfocus();
      widget.onSubmit(
        _userNameTextController.text,
        _emailTextController.text,
        _passwordTextController.text,
      );
    }
  }
}

/// Register Page
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isProcessing = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const FloatyBackgroundWidget(),
          // Content
          Column(
            children: [
              // Custom header with Login button
              Container(
                height: 75.0,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, HOME_ROUTE);
                      },
                      child: Image.asset(
                        "assets/logo.png",
                        height: 55.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                    // Login button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LOGIN_ROUTE);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text('Login'),
                    ),
                  ],
                ),
              ),
              // Main content area with scrolling
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Register form
                      Container(
                        height: 500,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: AuthContainer(
                            headerText: "Register",
                            child: RegisterForm(
                              isProcessing: _isProcessing,
                              errorMessage: _errorMessage,
                              onSubmit: (username, email, password) async {
                                setState(() {
                                  _isProcessing = true;
                                  _errorMessage = null;
                                });

                                try {
                                  final user = await registerUser(
                                    username,
                                    email,
                                    password,
                                  );

                                  setState(() {
                                    _isProcessing = false;
                                  });

                                  if (user != null) {
                                    Navigator.pushNamed(
                                      context,
                                      EMAIL_VERIFICATION_ROUTE,
                                      arguments: username,
                                    );
                                  }
                                } catch (e) {
                                  setState(() {
                                    _isProcessing = false;
                                    _errorMessage =
                                        'Registration failed. Please try again.';
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Register logic helper
Future<User?> registerUser(
  String username,
  String email,
  String password,
) async {
  final apiClient = ApiClient(basePath: backendUrl);
  final authApi = AuthApi(apiClient);

  final registerRequest = RegisterRequest(
    username: username,
    email: email,
    password: password,
  );

  try {
    return await authApi.registerUser(registerRequest);
  } catch (e) {
    throw Exception('Failed to register user: $e');
  }
}
