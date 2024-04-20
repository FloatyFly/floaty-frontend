import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'profile_page.dart';
import 'register_page.dart';
import 'fire_auth.dart';
import 'validator.dart';

// Google SingleSignon
import 'package:google_sign_in/google_sign_in.dart';

// Assuming DotGridPainter is defined somewhere accessible

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  bool _isProcessing = false;

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Provider.of<MyAppState>(context, listen: false).login(user);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MyHomePage()));
    }
    return firebaseApp;
  }



  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: "207967111919-risi1sc1p1fi5e2rg5ofreee8a5g5bhh.apps.googleusercontent.com",
    );
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }


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
          // Login Form
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 80.0,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ModernFont',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 100.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
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
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  _focusEmail.unfocus();
                                  _focusPassword.unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _isProcessing = true;
                                    });
                                    User? user = await FireAuth.signInUsingEmailPassword(
                                      email: _emailTextController.text,
                                      password: _passwordTextController.text,
                                      context: context,
                                    );
                                    setState(() {
                                      _isProcessing = false;
                                    });
                                    if (user != null) {
                                      Provider.of<MyAppState>(context, listen: false).login(user);
                                    }
                                  }
                                },
                                child: Text('Sign In', style: TextStyle(color: Colors.black)),
                              ),
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPage()));
                                },
                                child: Text('Register', style: TextStyle(color: Colors.black)),
                              ),
                            ),
                            SizedBox(height: 20),
                            Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      print("Google Sign-In button pressed");
                                      UserCredential userCredential = await signInWithGoogle();
                                      print("Signed in with Google: ${userCredential.user}");
                                      // Navigate to your main app screen or handle the user sign-in
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => RegisterPage())); // Adjust as necessary
                                    } catch (error) {
                                      print("Error signing in with Google: $error");
                                      // You can show an error message to the user here
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text("Login Error"),
                                          content: Text("Failed to sign in with Google. Please try again."),
                                          actions: [
                                            TextButton(
                                              child: Text("OK"),
                                              onPressed: () => Navigator.of(context).pop(),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                  child: Text('Sign in with Google'),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.black, backgroundColor: Colors.white, // Text color
                                  ),
                                )
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}



