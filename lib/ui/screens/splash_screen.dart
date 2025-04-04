import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sweet_balance/ui/screens/home_screen.dart';
import 'package:sweet_balance/ui/screens/welcome_screen.dart';

/// SplashScreen is the first screen shown when the app launches.
/// It serves as a transition while we check the user's authentication status.
class SplashScreen extends StatefulWidget {
  final int duration;

  /// [duration] lets you customize how long the splash screen stays visible.
  const SplashScreen({
    super.key,
    this.duration = 3,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // We delay for a few seconds to show the splash logo,
    // and then decide whether to navigate the user to the HomePage
    // or to the WelcomeScreen based on their authentication status.
    Future.delayed(Duration(seconds: widget.duration), () {
      final user = FirebaseAuth.instance.currentUser;

      // If user is already logged in, go to home screen,
      // otherwise welcome the user
      final Widget nextPage = user != null
          ? const HomePage()
          : const WelcomeScreen();

      // Make sure the widget is still in the tree before navigating
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => nextPage),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The splash screen UI is just a centered logo over a
      // background color
      body: Container(
        color: Colors.teal,
        alignment: Alignment.center,
        child: SvgPicture.asset(
          'assets/images/svg/app_logo.svg',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
