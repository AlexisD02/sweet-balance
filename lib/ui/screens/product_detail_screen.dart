import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/nutrition_overview.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    final barcode = widget.product.barcode;

    if (user == null || barcode == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(barcode)
        .get();

    if (mounted) {
      setState(() {
        isFavorite = doc.exists;
      });
    }
  }

  Future<void> _handleAddToTracker() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to track products')),
      );
      return;
    }

    final nutriments = widget.product.nutriments;
    final data = {
      'code': widget.product.barcode ?? '',
      'name': widget.product.productName ?? 'Unknown Product',
      'timestamp': FieldValue.serverTimestamp(),
      'energyKCal': nutriments?.getValue(Nutrient.energyKCal, PerSize.oneHundredGrams) ?? 0.0,
      'fat': nutriments?.getValue(Nutrient.fat, PerSize.oneHundredGrams) ?? 0.0,
      'proteins': nutriments?.getValue(Nutrient.proteins, PerSize.oneHundredGrams) ?? 0.0,
      'sugars': nutriments?.getValue(Nutrient.sugars, PerSize.oneHundredGrams) ?? 0.0,
    };

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tracker')
          .add(data);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to Tracker!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _handleToggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;

    final code = widget.product.barcode;
    if (code == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing product info.')),
      );
      return;
    }

    final favRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('favorites')
        .doc(code);

    try {
      if (isFavorite) {
        await favRef.delete();
      } else {
        await favRef.set({
          'productCode': code,
          'productName': widget.product.productName ?? '',
          'brand': widget.product.brands ?? '',
          'imageUrl': widget.product.imageFrontUrl ?? '',
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      if (!mounted) return;
      setState(() {
        isFavorite = !isFavorite;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFavorite ? 'Added to Favorites!' : 'Removed from Favorites.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating favorites: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: const Text(
                  'Product Details',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    product.imageFrontUrl != null
                        ? Image.network(
                      product.imageFrontUrl!,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      height: 300,
                      width: double.infinity,
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: const Icon(
                          Icons.fastfood,
                          size: 60,
                          color: Colors.white
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.black54,
                          ),
                          onPressed: _handleToggleFavorite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 20.0
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.productName ?? "Unknown Product",
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        product.brands ?? "Unknown Brand",
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54
                        ),
                      ),
                      const SizedBox(height: 24),
                      NutritionOverview(nutriments: product.nutriments),
                      const SizedBox(height: 24),
                      const Text(
                        "Ingredients",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.ingredientsText ?? "No ingredient info.",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 75), // Space for bottom button
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.85),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: _handleAddToTracker,
                  child: const Text(
                    "Add to Tracker",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
