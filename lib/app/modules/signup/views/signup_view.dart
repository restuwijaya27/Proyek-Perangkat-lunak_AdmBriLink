import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/controllers/auth_controller.dart';
import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  final cAuth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with Blue Background
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.04,
                    horizontal: MediaQuery.of(context).size.width * 0.05),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0D47A1), Color(0xFF1565C0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/bri.jpg',
                      height: MediaQuery.of(context).size.height *
                          0.30, // Increased from 0.04
                      width: MediaQuery.of(context).size.width *
                          0.6, // Increased from 0.05
                      fit: BoxFit.contain,
                      color: Colors.white,
                    ),
                    Text(
                      "Create Your Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).textScaler.scale(24),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Signup Form
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildInputField(
                      controller: controller.cEmail,
                      labelText: "Email",
                      icon: Icons.email,
                      borderColor: Color(0xFF0D47A1),
                    ),
                    SizedBox(height: 20),
                    _buildInputField(
                      controller: controller.cPass,
                      labelText: "Password",
                      icon: Icons.lock,
                      obscureText: true,
                      borderColor: Color(0xFF0D47A1),
                    ),
                    SizedBox(height: 30),

                    // Signup Button
                    ElevatedButton(
                      onPressed: () {
                        cAuth.signup(
                            controller.cEmail.text, controller.cPass.text);
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0D47A1),
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Login Navigation Button
                    TextButton(
                      onPressed: () {
                        // Assuming you have a named route for login page
                        Get.toNamed('/login');
                      },
                      child: Text(
                        "Already have an account? Log In",
                        style: TextStyle(
                          color: Color(0xFF0D47A1),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required Color borderColor,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: borderColor),
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor.withOpacity(0.5), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
      ),
    );
  }
}
