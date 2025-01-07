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
              // Header with Modern Gradient and Illustration
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.05,
                    horizontal: MediaQuery.of(context).size.width * 0.05),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0077B6), Color(0xFF0096C7)],
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
                      'assets/images/illustration.png',
                      height: MediaQuery.of(context).size.height * 0.25,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Create Your Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
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
                      borderColor: Color(0xFF0077B6),
                    ),
                    SizedBox(height: 20),
                    _buildInputField(
                      controller: controller.cPass,
                      labelText: "Password",
                      icon: Icons.lock,
                      obscureText: true,
                      borderColor: Color(0xFF0077B6),
                    ),
                    SizedBox(height: 30),

                    // Signup Button with Animation
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
                        backgroundColor: Color(0xFF0077B6),
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Social Media Sign Up Options
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.facebook, color: Color(0xFF0077B6)),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.g_mobiledata, color: Color(0xFF0077B6)),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.apple, color: Color(0xFF0077B6)),
                          onPressed: () {},
                        ),
                      ],
                    ),

                    // Login Navigation Button
                    TextButton(
                      onPressed: () {
                        Get.toNamed('/login');
                      },
                      child: Text(
                        "Already have an account? Log In",
                        style: TextStyle(
                          color: Color(0xFF0077B6),
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
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: borderColor.withOpacity(0.5), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
      ),
    );
  }
}
