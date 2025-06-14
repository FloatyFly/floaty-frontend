import 'package:flutter/material.dart';
import 'package:floaty_client/api.dart';
import '../config/constants.dart';
import '../widgets/ui_components.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  bool _isProcessing = false;
  String? _message;
  bool _isSuccess = false;

  Future<void> _verifyEmail(String token) async {
    setState(() {
      _isProcessing = true;
      _message = null;
      _isSuccess = false;
    });

    try {
      final apiClient = ApiClient(basePath: backendUrl);
      final authApi = AuthApi(apiClient);

      await authApi.authVerifyEmailEmailVerificationTokenPost(token);

      setState(() {
        _isProcessing = false;
        _message =
            "Your email has been successfully verified! You may now continue to login.";
        _isSuccess = true;
      });
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _message =
            "Verification failed. The token might be invalid or expired.";
        _isSuccess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          const FloatyBackgroundWidget(),
          // AuthContainer with Email Verification Form
          Header(),
          AuthContainer(
            headerText: "Email Verification",
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 40.0),
                  // Instruction Text
                  const Text(
                    "Only one step left to using Floaty! Please check your email for the email verification token to enter below.",
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40.0),

                  // Token Input Field
                  TextFormField(
                    controller: _tokenController,
                    decoration: const InputDecoration(
                      hintText: "Enter Verification Code",
                      prefixIcon: Icon(Icons.code, color: Colors.grey),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the verification code.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // Error or Success Message
                  if (_message != null)
                    Text(
                      _message!,
                      style: TextStyle(
                        color: _isSuccess ? Colors.green : Colors.red,
                        fontSize: 14.0,
                      ),
                    ),
                  const SizedBox(height: 32.0),

                  // Verify Button
                  _isProcessing
                      ? const CircularProgressIndicator()
                      : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_isSuccess) {
                              Navigator.pushNamed(context, LOGIN_ROUTE);
                            } else if (_formKey.currentState!.validate()) {
                              _verifyEmail(_tokenController.text);
                            }
                          },
                          child: Text(
                            _isSuccess ? 'Go to Login' : 'Verify Email',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
