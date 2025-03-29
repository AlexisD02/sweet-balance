import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sweet_balance/ui/screens/home_screen.dart';
import 'package:sweet_balance/ui/screens/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  final int duration;

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

    Future.delayed(Duration(seconds: widget.duration), () {
      final user = FirebaseAuth.instance.currentUser;

      final Widget nextPage = user != null
          ? const HomePage()
          : const WelcomeScreen();

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