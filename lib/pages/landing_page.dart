import 'package:floaty/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'package:floaty/widgets/ui_components.dart'; // Assuming you have AuthContainer and FloatyBackgroundWidget

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Scaffold(
          body: Stack(
            children: [
              const FloatyBackgroundWidget(),

              // Top White Banner
              Positioned(left: 0, right: 0, top: 0, child: Header()),

              // Main Content wrapped in SingleChildScrollView
              SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      SizedBox(height: 250.0), // Spacing below the top banner
                      // AuthContainer for Register Form
                      AuthContainer(
                        headerText: "Welcome",
                        child: Form(
                          child: RegisterForm(
                            onSubmit: (username, email, password) async {
                              // Handle registration logic here
                            },
                            errorMessage: null,
                            isProcessing: false,
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
      },
    );
  }
}
