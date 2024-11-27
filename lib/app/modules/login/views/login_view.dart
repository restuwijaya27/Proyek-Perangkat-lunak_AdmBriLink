import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/controllers/auth_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final cAuth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate dynamic padding and sizes
    final horizontalPadding = screenWidth * 0.06;
    final logoHeight = screenHeight * 0.08;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(
                  0xFF005FAF), // Slightly brighter BRI Blue for better contrast
              Color(0xFF003C71), // Darker BRI Blue
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight - MediaQuery.of(context).padding.top,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.06),

                    // Logo Section with specific dimensions
                    Container(
                      width: screenWidth * 0.5, // Lebih besar: 80% lebar layar
                      height:
                          screenHeight * 0.20, // Lebih besar: 25% tinggi layar
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            25), // Border yang lebih halus
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 15,
                            offset:
                                Offset(0, 8), // Bayangan sedikit lebih lembut
                          ),
                        ],
                      ),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              20), // Sesuai dengan border container
                          child: Image.asset(
                            "assets/images/bri.jpg",
                            width:
                                screenWidth * 0.7, // Gambar lebih proporsional
                            height: screenHeight * 0.2,
                            fit:
                                BoxFit.cover, // Isi area dengan proporsi gambar
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // Welcome Text
                    Text(
                      "Selamat Datang",
                      style: TextStyle(
                        fontSize: screenHeight * 0.034,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    Text(
                      "ADM Bri Link",
                      style: TextStyle(
                        fontSize: screenHeight * 0.02,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 0.5,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0),

                    // Email Field
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: controller.cEmail,
                        style: TextStyle(
                          color: Color(0xFF2D2D2D),
                          fontSize: screenHeight * 0.018,
                        ),
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: screenHeight * 0.018,
                          ),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Color(0xFF005FAF),
                            size: screenHeight * 0.026,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                            horizontal: screenWidth * 0.04,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0),

                    // Password Field
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: controller.cPass,
                        obscureText: true,
                        style: TextStyle(
                          color: Color(0xFF2D2D2D),
                          fontSize: screenHeight * 0.018,
                        ),
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: screenHeight * 0.018,
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Color(0xFF005FAF),
                            size: screenHeight * 0.026,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                            horizontal: screenWidth * 0.04,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Login Button
                    Container(
                      width: double.infinity,
                      height: screenHeight * 0.062,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFFBB040), // BRI Orange
                            Color(0xFFF7941D), // Darker BRI Orange
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFFBB040).withOpacity(0.3),
                            spreadRadius: 0,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          cAuth.login(
                              controller.cEmail.text, controller.cPass.text);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: screenHeight * 0.02,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.0),

                    // Reset Password Link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.offAllNamed(Routes.RESET_PASSWORD);
                        },
                        child: Text(
                          "Reset Password",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenHeight * 0.016,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0),

                    // Sign Up Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Belum Punya Akun ?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenHeight * 0.016,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.offAllNamed(Routes.SIGNUP);
                          },
                          child: Text(
                            "Daftar Disini",
                            style: TextStyle(
                              color: Color(0xFFFBB040),
                              fontWeight: FontWeight.bold,
                              fontSize: screenHeight * 0.016,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
