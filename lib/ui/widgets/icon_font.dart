import 'package:flutter/material.dart';

class IconFont extends StatelessWidget {
  final Color? color;
  final double? size;
  final String iconName;
  final String fontFamily;

  const IconFont({
    super.key,
    this.color = Colors.white,
    this.size = 100,
    required this.iconName,
    this.fontFamily = 'Arial',
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      iconName,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontFamily: fontFamily,
      ),
    );
  }
}
