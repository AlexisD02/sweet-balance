import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

import 'package:sweet_balance/ui/screens/product_detail_screen.dart';
import 'package:sweet_balance/ui/screens/search_screen.dart';

class RecipesInfoCard extends StatelessWidget {
  final String title;
  final List<Product> products;
  final bool isLoading;
  final SortOption sortOption;

  const RecipesInfoCard({
    super.key,
    required this.title,
    required this.products,
    this.isLoading = false,
    required this.sortOption,
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
            color: Colors.black.withValues(alpha: 0.1),
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
                Text(title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                if (isLoading)
                  const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()))
                else if (products.isEmpty)
                  const SizedBox(
                    height: 100,
                    child: Center(child: Text('No recipes found', style: TextStyle(color: Colors.grey))),
                  )
                else
                  SizedBox(
                    height: 130,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailScreen(product: product),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Column(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: Colors.grey[300],
                                    image: product.imageFrontUrl != null
                                        ? DecorationImage(
                                      image: NetworkImage(product.imageFrontUrl!),
                                      fit: BoxFit.cover,
                                    )
                                        : null,
                                  ),
                                  child: product.imageFrontUrl == null
                                      ? const Icon(Icons.fastfood, size: 40, color: Colors.grey)
                                      : null,
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    product.productName ?? 'Unknown Product',
                                    style: const TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
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
          ),

          Positioned(
            top: 20.0,
            right: 20.0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SearchScreen(initialSort: sortOption),
                  ),
                );
              },
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 18.0,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
