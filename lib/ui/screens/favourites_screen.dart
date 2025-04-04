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
  List<Map<String, dynamic>> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final query = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .orderBy('timestamp', descending: true)
        .get();

    setState(() {
      _favorites = query.docs.map((doc) => doc.data()).toList();
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
          ? const Center(child: CircularProgressIndicator())
          : _favorites.isEmpty
          ? const Center(child: Text('No favourites yet.'))
          : ListView.builder(
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final item = _favorites[index];
          return ListTile(
            leading: item['imageUrl'] != ''
                ? ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                item['imageUrl'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            )
                : const Icon(Icons.fastfood, size: 40),
            title: Text(item['productName']),
            subtitle: Text(item['brand'] ?? 'Unknown Brand'),
            onTap: () async {
              final productName = item['productCode'];
              if (productName == null || productName.isEmpty) return;

              final config = ProductQueryConfiguration(
                productName,
                version: ProductQueryVersion.v3,
                language: OpenFoodFactsLanguage.ENGLISH,
                fields: [ProductField.ALL],
              );

              final result = await OpenFoodAPIClient.getProductV3(config);

              if (result.product != null && context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(product: result.product!),
                  ),
                );
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to load product details')),
                  );
                }
              }
            },
          );
        },
      ),
    );
  }
}
