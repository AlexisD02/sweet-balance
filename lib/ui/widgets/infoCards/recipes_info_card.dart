import 'package:flutter/material.dart';

class RecipesInfoCard extends StatelessWidget {
  final String title;
  final List<Map<String, String>> items;

  const RecipesInfoCard({
    super.key,
    required this.title,
    required this.items,
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
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Column(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: Colors.grey[300],
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.fastfood,
                                  size: 40,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item['title']!,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 20.0,
            right: 20.0,
            child: GestureDetector(
              onTap: () {
                // todo
              },
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 20.0,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
