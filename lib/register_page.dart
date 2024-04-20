import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_page.dart';
import 'validator.dart';
import 'fire_auth.dart';

// Assuming DotGridPainter is defined somewhere accessible

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey.withOpacity(0.5),
          ),
          // Dot Grid Overlay
          Positioned.fill(
            child: CustomPaint(
              painter: DotGridPainter(),
            ),
          ),
          // Registration Form
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Register',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 80.0,
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ModernFont',
                      ),
                    ),
                    Form(
                      key: _registerFormKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _nameTextController,
                            focusNode: _focusName,
                            validator: (value) => Validator.validateName(name: value),
                            decoration: InputDecoration(hintText: "Name"),
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: _emailTextController,
                            focusNode: _focusEmail,
                            validator: (value) => Validator.validateEmail(email: value),
                            decoration: InputDecoration(hintText: "Email"),
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: _passwordTextController,
                            focusNode: _focusPassword,
                            obscureText: true,
                            validator: (value) => Validator.validatePassword(password: value),
                            decoration: InputDecoration(hintText: "Password"),
                          ),
                          SizedBox(height: 32.0),
                          _isProcessing
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                            onPressed: () async {
                              _focusName.unfocus();
                              _focusEmail.unfocus();
                              _focusPassword.unfocus();
                              if (_registerFormKey.currentState!.validate()) {
                                setState(() { _isProcessing = true; });
                                User? user = await FireAuth.registerUsingEmailPassword(
                                  name: _nameTextController.text,
                                  email: _emailTextController.text,
                                  password: _passwordTextController.text,
                                );
                                setState(() { _isProcessing = false; });
                                if (user != null) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => ProfilePage(user: user),
                                    ),
                                    ModalRoute.withName('/'),
                                  );
                                }
                              }
                            },
                            child: Text('Sign up'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor, // Use the primary color for the button
                            ),
                          ),
                        ],
                      ),
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
