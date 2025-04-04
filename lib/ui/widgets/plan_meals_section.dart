import 'package:flutter/material.dart';

import '../screens/favourites_screen.dart';

class PlanMealsCardInfo extends StatelessWidget {
  const PlanMealsCardInfo({super.key});

  static const List<Map<String, dynamic>> items = [
    {'title': 'My Favourites', 'icon': Icons.favorite, 'color': Colors.blue},
    {'title': 'Meal Planning', 'icon': Icons.calendar_month, 'color': Colors.red},
    {'title': 'Print Weekly Meals', 'icon': Icons.print_rounded, 'color': Colors.green},
    {'title': 'Upload Recipe', 'icon': Icons.cloud_upload, 'color': Colors.deepOrange},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () {
                    if (item['title'] == 'My Favourites') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FavouritesScreen()),
                      );
                    }
                  },
                  child: Container(
                    width: 110,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: item['color']!.withOpacity(0.1),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Icon(
                            item['icon'],
                            size: 32,
                            color: item['color'],
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          child: Text(
                            item['title']!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
