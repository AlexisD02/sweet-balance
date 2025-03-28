import 'package:flutter/material.dart';

import '../../screens/insulin_calculator_screen.dart';

class InsulinCalculatorInfoCard extends StatelessWidget {
  final double insulinDose;
  final double carbIntake;
  final double insulinSensitivityFactor;
  final double targetBloodSugar;
  final bool isEditMode;
  final VoidCallback? onRemove;

  const InsulinCalculatorInfoCard({
    super.key,
    required this.insulinDose,
    required this.carbIntake,
    required this.insulinSensitivityFactor,
    required this.targetBloodSugar,
    this.isEditMode = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Row with Icon
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: const Icon(
                        Icons.calculate,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Insulin/Bolus Calculator",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Main Row with big insulin dose and extra info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          insulinDose.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 36.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Text(
                            "Units",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Carb Intake",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          "$carbIntake g",
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Sensitivity Factor",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          "$insulinSensitivityFactor mg/dL",
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Buttons Row
                OutlinedButton(
                  onPressed: () {
                    // Navigate to detail screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InsulinCalculatorDetailScreen(
                          insulinDose: insulinDose,
                          carbIntake: carbIntake,
                          insulinSensitivityFactor: insulinSensitivityFactor,
                          targetBloodSugar: targetBloodSugar,
                        ),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                    side: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  child: const Text(
                    "View Details",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Edit mode remove icon
          if (isEditMode && onRemove != null)
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: onRemove,
                child: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.red,
                  size: 28,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
