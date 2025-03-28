import 'package:flutter/material.dart';
import 'package:sweet_balance/ui/screens/home_screen.dart';
import 'package:sweet_balance/ui/screens/splash_screen.dart';
import 'package:sweet_balance/ui/screens/welcome_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SweetBalance',
      home: const SplashScreen(duration: 3, goToPage: WelcomeScreen()),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}