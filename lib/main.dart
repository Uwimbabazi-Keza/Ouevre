import 'package:flutter/material.dart';
import 'package:ouevre/screens/login_page.dart';
import 'package:ouevre/colors.dart';
import 'package:ouevre/screens/splash_screen.dart';

void main() {
  runApp(OuevreApp());
}

class OuevreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ouevre',
      theme: ThemeData(primaryColor: AppColors.primaryColor),
      // Set SplashScreen as the initial route
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        // Add other routes as needed
      },
    );
  }
}
