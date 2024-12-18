import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:floaty_client/api.dart';
import 'constants.dart';
import 'ui_components.dart';

class EmailVerificationPage extends StatefulWidget {
  final String verificationToken;

  const EmailVerificationPage({Key? key, required this.verificationToken}) : super(key: key);

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool _isProcessing = true;
  String? _message;

  @override
  void initState() {
    super.initState();
    _verifyEmail();
  }

  Future<void> _verifyEmail() async {
    try {
      final apiClient = ApiClient(basePath: BASE_URL);
      final authApi = AuthApi(apiClient);

      await authApi.authVerifyEmailEmailVerificationTokenPost(widget.verificationToken);
      setState(() {
        _isProcessing = false;
        _message = "Your email has been successfully verified!";
      });
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _message = "Verification failed. The token might be invalid or expired.";
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
          // Verification Status
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isProcessing)
                    CircularProgressIndicator()
                  else
                    Column(
                      children: [
                        Icon(
                          _message == "Your email has been successfully verified!"
                              ? Icons.check_circle
                              : Icons.error,
                          color: _message == "Your email has been successfully verified!"
                              ? Colors.green
                              : Colors.red,
                          size: 64.0,
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          _message!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 32.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, LOGIN_ROUTE);
                          },
                          child: Text(
                            'Go to Login',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
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
