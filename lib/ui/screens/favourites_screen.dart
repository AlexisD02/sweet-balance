import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'product_detail_screen.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  List<Map<String, dynamic>> _favouriteProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites(); // Start loading user's favourites on screen init
  }

  // Fetches favourite products from Firestore (sorted by latest)
  Future<void> _loadFavorites() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('favorites')
        .orderBy('timestamp', descending: true)
        .get();

    setState(() {
      _favouriteProducts = snapshot.docs.map((doc) => doc.data()).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favourites'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: _isLoading
      // Show loading spinner while data is being fetched
          ? const Center(child: CircularProgressIndicator())

      // Show message if no favourites found
          : _favouriteProducts.isEmpty
          ? const Center(child: Text('No favourites yet.'))

      // Display list of favourite products
          : ListView.builder(
        itemCount: _favouriteProducts.length,
        itemBuilder: (context, index) {
          final product = _favouriteProducts[index];

          return ListTile(
            leading: product['imageUrl'] != ''
            // If image URL exists, show image
                ? ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                product['imageUrl'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            )
            // Otherwise show fallback icon
                : const Icon(Icons.fastfood, size: 40),

            title: Text(product['productName']),
            subtitle: Text(product['brand'] ?? 'Unknown Brand'),

            onTap: () async {
              final productCode = product['productCode'];

              // Skip if productCode is missing or empty
              if (productCode == null || productCode.isEmpty) return;

              // Create request config for OpenFoodFacts
              final query = ProductQueryConfiguration(
                productCode,
                version: ProductQueryVersion.v3,
                language: OpenFoodFactsLanguage.ENGLISH,
                fields: [ProductField.ALL],
              );

              final result = await OpenFoodAPIClient.getProductV3(query);

              // Navigate to product details if found
              if (result.product != null && context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(product: result.product!),
                  ),
                );
              } else if (context.mounted) {
                // Show error if product not found
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to load product details')),
                );
              }
            },
          );
        },
      ),
    );
  }
}
