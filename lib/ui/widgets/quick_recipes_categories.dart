import 'package:flutter/material.dart';

class QuickRecipesCategories extends StatelessWidget {
  const QuickRecipesCategories({super.key});

  static const List<Map<String, dynamic>> categories = [
    {'title': 'Breakfast & Brunch', 'icon': Icons.breakfast_dining, 'color': Colors.orange},
    {'title': 'Lunch', 'icon': Icons.lunch_dining, 'color': Colors.blue},
    {'title': 'Main Course', 'icon': Icons.dinner_dining, 'color': Colors.red},
    {'title': 'Beverages', 'icon': Icons.local_drink, 'color': Colors.teal},
    {'title': 'Dinner', 'icon': Icons.nightlife, 'color': Colors.deepPurple},
    {'title': 'Snacks', 'icon': Icons.fastfood, 'color': Colors.green},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return SizedBox(
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: category['color']!.withOpacity(0.1),
                      ),
                      child: Center(
                        child: Icon(
                          category['icon'],
                          size: 26,
                          color: category['color'],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 40,
                      child: Text(
                        category['title']!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
