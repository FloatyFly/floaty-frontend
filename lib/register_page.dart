import 'package:flutter/material.dart';
import 'package:floaty_client/api.dart';
import 'constants.dart';
import 'validator.dart';
import 'ui_components.dart';

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
                style: TextStyle(
                  color: Colors.black,
                ),
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
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, LOGIN_ROUTE);
                },
                child: const Text(
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
    );
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
          // Background
          const FloatyBackgroundWidget(),
          Header(),
          // AuthContainer with RegisterForm
          AuthContainer(
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
                  await registerUser(username, email, password);

                  setState(() {
                    _isProcessing = false;
                  });

                  Navigator.pushNamed(context, EMAIL_VERIFICATION_ROUTE);
                } catch (e) {
                  setState(() {
                    _isProcessing = false;
                    _errorMessage = 'Registration failed. Please try again.';
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

/// Register logic helper
Future<User?> registerUser(String username, String email, String password) async {
  final apiClient = ApiClient(basePath: backendUrl);
  final authApi = AuthApi(apiClient);

  final registerRequest = RegisterRequest(
    username: username,
    email: email,
    password: password,
  );

  return await authApi.registerUser(registerRequest);
}
