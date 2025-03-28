import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  final int duration;
  final Widget goToPage;

  const SplashScreen({
    super.key,
    required this.goToPage,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: duration), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => goToPage),
      );
    });

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
