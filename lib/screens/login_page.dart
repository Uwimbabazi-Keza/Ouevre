import 'package:flutter/material.dart';
import 'package:ouevre/colors.dart'; // Import your color reference
import 'package:google_fonts/google_fonts.dart';
import 'package:ouevre/screens/home_screen.dart'; // Import HomeScreen
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
    serverClientId: '291053451217-bj7npkpbrj4j3930kfsgsbed06rb56l7.apps.googleusercontent.com',
  );

  String email = '';
  String password = '';
  String errorMessage = '';

  Future<User?> _signInWithGoogle() async {
    try {
      // Ensure that Google Sign-In is only initialized once
      if (_googleSignIn.currentUser == null) {
        await _googleSignIn.signIn();
      }

      final GoogleSignInAccount? googleSignInAccount = _googleSignIn.currentUser;
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;
        return user;
      }
    } catch (error) {
      print('Google Sign-In Error: $error');
      return null;
    }
    return null;
  }

  void _signIn(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      print('Login failed: $e');
      // Handle login failure (show error message, etc.)
    }
  }

  void _signUp(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Save additional user data to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'email': email,
          // Other user details
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      print('Sign-up failed: $e');
      // Handle sign-up failure (email already exists, invalid password, etc.)
    }
  }

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
                  onTap: () async {
                    // Implement Google sign-in logic here
                    User? user = await _signInWithGoogle();
                    if (user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    }
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
                  onChanged: (value) {
                    // Update the email variable when text changes
                    setState(() {
                      email = value.trim(); // Trim any whitespace from the input
                    });
                  },
                ),
                SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                  ),
                  onChanged: (value) {
                    // Update the password variable when text changes
                    setState(() {
                      password = value.trim(); // Trim any whitespace from the input
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Pass collected email and password to _signIn method
                    _signIn(context);
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
                      'Log In',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Pass collected email and password to _signUp method
                    _signUp(context);
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
                      'Sign Up',
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
