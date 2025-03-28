import 'package:flutter/material.dart';

import '../../../utils/blood_sugar_utils.dart';
import '../../screens/blood_glucose_screen.dart';

class BloodSugarInfoCard extends StatelessWidget {
  final double currentBloodSugar;
  final List<double> sugarTrend;
  final double targetMin;
  final double targetMax;
  final bool isEditMode;
  final VoidCallback? onRemove;

  const BloodSugarInfoCard({
    super.key,
    required this.currentBloodSugar,
    this.sugarTrend = const [],
    required this.targetMin,
    required this.targetMax,
    this.isEditMode = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    bool isInTargetRange =
    BloodSugarUtils.isInTargetRange(currentBloodSugar, targetMin, targetMax);
    double progress =
    BloodSugarUtils.calculateProgress(currentBloodSugar, targetMin, targetMax);

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
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.teal,
                      ),
                      child: const Icon(
                        Icons.water_drop,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),

                    const SizedBox(width: 8),
                    const Text(
                      "Blood Glucose",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      currentBloodSugar.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                        color: isInTargetRange ? Colors.teal : Colors.red,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text(
                        "mg/dL",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    const Spacer(),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Target: $targetMin-$targetMax",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 10,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            Positioned(
                              left: (progress * 150) - 3,
                              child: Container(
                                height: 12,
                                width: 6,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BloodSugarDetailsScreen(
                          sugarTrend: sugarTrend,
                          targetMin: targetMin,
                          targetMax: targetMax,
                        ),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                    side: const BorderSide(color: Colors.teal, width: 2),
                  ),
                  child: const Text(
                    "View Details",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

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
