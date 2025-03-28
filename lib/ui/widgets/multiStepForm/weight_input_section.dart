import 'package:flutter/material.dart';

class WeightInputSection extends StatelessWidget {
  final TextEditingController controller;
  final String? errorMessage;

  const WeightInputSection({
    required this.controller,
    this.errorMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            text: "What's your ",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: "latest",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: " weight?"),
            ],
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Weight in kg",
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
              return 'Please enter your weight.';
            }
            final weight = double.tryParse(value);
            if (weight == null) {
              return 'Please enter a valid number.';
            }
            if (weight < 30 || weight > 300) {
              return 'Please enter a number between 30 and 300.';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        const Text(
          "You can update your weight at any time.",
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
