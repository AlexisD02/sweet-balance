import 'package:flutter/material.dart';

class InfoMessage extends StatelessWidget {
  const InfoMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.teal),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              "Why do you need this information? To effectively calculate your calories, macros, and carb intake",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}