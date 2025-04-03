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

    final calories = nutriments!.getValue(Nutrient.energyKCal, PerSize.oneHundredGrams) ?? 0;
    final protein = nutriments!.getValue(Nutrient.proteins, PerSize.oneHundredGrams) ?? 0;
    final fat = nutriments!.getValue(Nutrient.fat, PerSize.oneHundredGrams) ?? 0;
    final carbs = nutriments!.getValue(Nutrient.carbohydrates, PerSize.oneHundredGrams) ?? 0;
    final sugars = nutriments!.getValue(Nutrient.sugars, PerSize.oneHundredGrams) ?? 0;
    final fiber = nutriments!.getValue(Nutrient.fiber, PerSize.oneHundredGrams) ?? 0;
    final salt = nutriments!.getValue(Nutrient.salt, PerSize.oneHundredGrams) ?? 0;

    Widget buildRow(String label, double value, Color color) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Text(
              "${value.toStringAsFixed(1)}g",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          buildRow("Calories", calories, Colors.grey),
          buildRow("Carbohydrates", carbs, Colors.redAccent),
          buildRow("Sugars", sugars, Colors.red.shade300),
          buildRow("Fat", fat, Colors.orange),
          buildRow("Protein", protein, Colors.blueAccent),
          buildRow("Fiber", fiber, Colors.green),
          buildRow("Salt", salt, Colors.purple),
        ],
      ),
    );
  }
}
