import 'package:flutter/material.dart';
import 'package:ouevre/screens/login_page.dart'; // Import your login page
import 'package:google_fonts/google_fonts.dart';
import 'package:ouevre/colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add any initialization tasks here, e.g., data loading, etc.
    // After a delay, navigate to the login page
    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Background image or color for your splash screen
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primaryColor, AppColors.secondaryColor],
              ),
            ),
          ),

          // Logo or branding element
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Replace this with your app logo or branding
                SizedBox(height: 16),
                Text(
                  'OUEVRE',
                  style: GoogleFonts.overlock(
                    textStyle: TextStyle(
                      letterSpacing: 3.5,
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
