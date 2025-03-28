import 'package:flutter/material.dart';

class HeightInputSection extends StatelessWidget {
  final TextEditingController controller;

  const HeightInputSection({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            text: "How ",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: "tall",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: " are you?"),
            ],
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Height in cm",
            labelStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.teal,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your height.';
            }
            final height = double.tryParse(value);
            if (height == null) {
              return 'Please enter a valid number.';
            }
            if (height < 50 || height > 300) {
              return 'Please enter a height between 50 and 300 cm.';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        const Text(
          "Ensure your height is accurate for precise tracking.",
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
