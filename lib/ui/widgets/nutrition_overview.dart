import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class NutritionOverview extends StatelessWidget {
  final Nutriments? nutriments;

  const NutritionOverview({super.key, required this.nutriments});

  @override
  Widget build(BuildContext context) {
    if (nutriments == null) {
      return const Text("No nutrition data available.");
    }

    final nutrientsToShow = {
      Nutrient.energyKCal: Colors.teal,
      Nutrient.fat: Colors.orange,
      Nutrient.proteins: Colors.blueAccent,
      Nutrient.sugars: Colors.redAccent,
    };

    Widget buildStatRow(Nutrient nutrient, double value, Color color) {
      final label = nutrient.offTag
          .replaceAll('-', ' ')
          .replaceFirst(nutrient.offTag[0], nutrient.offTag[0].toUpperCase());

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Text(
              "${value.toStringAsFixed(1)} ${UnitHelper.unitToString(nutrient.typicalUnit)}",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    final List<Widget> statRows = [];

    for (final entry in nutrientsToShow.entries) {
      final value = nutriments!.getValue(entry.key, PerSize.oneHundredGrams);
      if (value != null) {
        statRows.add(buildStatRow(entry.key, value, entry.value));
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Nutrition Information (per 100g):",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          ...statRows,
        ],
      ),
    );
  }
}
