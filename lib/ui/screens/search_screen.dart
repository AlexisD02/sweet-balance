import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

import '../widgets/food_item_card.dart';
import '../widgets/search_field.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  final List<Product> _searchResults = [];
  final bool _isLoading = false;
  final bool _hasError = false;

  final List<_SampleItem> _sampleItems = [
    _SampleItem(
      imageUrl: 'https://via.placeholder.com/600x400?text=Fast+Food',
      label: "Fast Food",
      description: "Often high in carbs & sugar",
    ),
    _SampleItem(
      imageUrl: 'https://via.placeholder.com/600x400?text=Pizza',
      label: "Pizza",
      description: "Check sauces & refined carbs",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final hasQuery = _searchQuery.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        centerTitle: false,
        elevation: 0,
        title: SearchField(
            placeholder: "Search for a product...",
            onChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _hasError
            ? const Center(
          child: Text(
            "An error occurred. Please try again.",
            style: TextStyle(color: Colors.red),
          ),
        )
            : (hasQuery && _searchResults.isEmpty)
            ? const Center(child: Text("No results found."))
            : hasQuery
            ? _buildSearchResults()
            : _buildSampleList(),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final product = _searchResults[index];
        return ListTile(
          leading: product.imageFrontUrl != null
              ? Image.network(product.imageFrontUrl!, width: 50)
              : const Icon(Icons.fastfood),
          title: Text(product.productName ?? "Unknown Product"),
          subtitle: Text(product.brands ?? "Unknown Brand"),
        );
      },
    );
  }

  Widget _buildSampleList() {
    return ListView.builder(
      itemCount: _sampleItems.length,
      itemBuilder: (context, index) {
        final item = _sampleItems[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: SampleItemCard(
            imageUrl: item.imageUrl,
            label: item.label,
            description: item.description,
          ),
        );
      },
    );
  }
}

class _SampleItem {
  final String imageUrl;
  final String label;
  final String description;

  _SampleItem({
    required this.imageUrl,
    required this.label,
    required this.description,
  });
}
