import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

import 'package:sweet_balance/ui/screens/search_screen.dart';

class QuickProductsCategories extends StatelessWidget {
  const QuickProductsCategories({super.key});

  static const List<Map<String, dynamic>> categories = [
    {'title': 'Drinks', 'icon': Icons.local_drink, 'color': Colors.teal, 'tag': 'drinks'},
    {'title': 'Snacks', 'icon': Icons.fastfood, 'color': Colors.green, 'tag': 'snacks'},
    {'title': 'Meals', 'icon': Icons.lunch_dining, 'color': Colors.deepOrange, 'tag': 'meals'},
    {'title': 'Breakfast', 'icon': Icons.breakfast_dining, 'color': Colors.orange, 'tag': 'breakfasts'},
    {'title': 'Fruits', 'icon': Icons.eco, 'color': Colors.pink, 'tag': 'fruit-based-beverages'},
    {'title': 'Sweets', 'icon': Icons.icecream, 'color': Colors.purple, 'tag': 'sweets'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(
                    initialSort: SortOption.POPULARITY,
                    initialCategoryFilter: category['tag'],
                  ),
                ),
              );
            },
            child: SizedBox(
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: category['color'].withOpacity(0.1),
                    ),
                    child: Icon(category['icon'], color: category['color'], size: 26),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category['title'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
