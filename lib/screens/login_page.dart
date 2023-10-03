import 'package:flutter/material.dart';
import 'package:ouevre/colors.dart'; // Import your color reference
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'OUEVRE', // Your app name
                  style: GoogleFonts.overlock(
                    textStyle: TextStyle(
                      letterSpacing: 3.5,
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor, // Use primary color
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'SIGN IN WITH',
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      letterSpacing: 2.5,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: AppColors.normaltextColor, // Use primary color
                    ),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    // Implement Google sign-in logic here
                  },
                  child: Image.asset(
                    'assets/google_logo.png', // Replace with the path to your Google image asset
                    width: 80, // Adjust the size as needed
                    height: 80, // Adjust the size as needed
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'OR',
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      letterSpacing: 2.5,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: AppColors.normaltextColor, // Use primary color
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Implement sign-in logic here
                  },
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.primaryColor, // Use primary color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: Size(double.infinity, 0), // Maximum width
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      'Sign In',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    // Implement "Forgot Password" logic here
                  },
                  child: Text(
                    'FORGOT PASSWORD?',
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w500,
                        fontSize: 14, // Adjust the font size as needed
                        color: AppColors.primaryColor, // Use primary color
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
