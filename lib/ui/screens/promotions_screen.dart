import 'package:flutter/material.dart';

class PromotionsScreen extends StatelessWidget {
  const PromotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example promotion items
    final promotions = [
      'Buy 1 Get 1 Free',
      '20% off on Premium Subscription',
      'Special Holiday Discount',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Promotions',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[200],
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[200],
        child: promotions.isEmpty
            ? const Center(
          child: Text(
            'No promotions available right now.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        )
            : ListView.builder(
          itemCount: promotions.length,
          itemBuilder: (context, index) {
            final promotion = promotions[index];
            return Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  promotion,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Limited time offer.',
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
                onTap: () {
                  // Example: Show promotion details, or open a purchase screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tapped on $promotion')),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
