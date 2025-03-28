import 'package:flutter/material.dart';

class SampleItemCard extends StatelessWidget {
  final String imageUrl;
  final String label;
  final String description;

  const SampleItemCard({
    super.key,
    required this.imageUrl,
    required this.label,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          SizedBox(
            height: 180,
            width: double.infinity,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),

          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          Positioned(
            left: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // todo Navigate to details or show sugar-tracking info
              },
              child: const SizedBox(
                height: 180,
                width: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
