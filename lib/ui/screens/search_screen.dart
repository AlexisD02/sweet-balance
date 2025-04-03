import 'dart:async';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

import 'package:sweet_balance/ui/screens/product_detail_screen.dart';
import '../widgets/search_field.dart';

class SearchScreen extends StatefulWidget {
  final SortOption initialSort;

  const SearchScreen({
    super.key,
    this.initialSort = SortOption.POPULARITY,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  List<Product> _products = [];
  bool _isLoading = false;
  bool _hasError = false;
  Timer? _debounce;

  SortOption _sortOption = SortOption.POPULARITY;

  @override
  void initState() {
    super.initState();
    _sortOption = widget.initialSort;
    fetchPopularProducts();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSortOptionChanged(SortOption selected) {
    setState(() => _sortOption = selected);
    if (_searchQuery.trim().isNotEmpty) {
      searchProducts(_searchQuery);
    } else {
      fetchPopularProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
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

            _debounce?.cancel();
            _debounce = Timer(const Duration(milliseconds: 800), () {
              if (_searchQuery.trim().isNotEmpty) {
                searchProducts(_searchQuery);
              } else {
                fetchPopularProducts();
              }
            });
          },
          onSortChanged: _onSortOptionChanged,
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
          : _products.isEmpty
          ? const Center(
        child: Text(
          "No results found.",
          style: TextStyle(color: Colors.black54),
        ),
      )
          : _buildProductList(),
    );
  }

  Future<void> fetchPopularProducts() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final config = ProductSearchQueryConfiguration(
        version: ProductQueryVersion.v3,
        language: OpenFoodFactsLanguage.ENGLISH,
        parametersList: [
          const PageSize(size: 20),
          SortBy(option: _sortOption),
        ],
        fields: [
          ProductField.NAME,
          ProductField.BRANDS,
          ProductField.IMAGE_FRONT_URL,
        ],
      );

      final result = await OpenFoodAPIClient.searchProducts(
        const User(userId: '0', password: ''),
        config,
      );

      setState(() {
        _products = result.products ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> searchProducts(String query) async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final config = ProductSearchQueryConfiguration(
        version: ProductQueryVersion.v3,
        language: OpenFoodFactsLanguage.ENGLISH,
        parametersList: [
          SearchTerms(terms: [query]),
          const PageSize(size: 20),
          SortBy(option: _sortOption),
        ],
        fields: [
          ProductField.NAME,
          ProductField.BRANDS,
          ProductField.IMAGE_FRONT_URL,
          ProductField.NUTRIMENTS,
          ProductField.INGREDIENTS_TEXT,
        ],
      );

      final result = await OpenFoodAPIClient.searchProducts(
        const User(userId: '0', password: ''),
        config,
      );

      setState(() {
        _products = result.products ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Widget _buildProductList() {
    return ListView.builder(
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        final imageUrl = product.imageFrontUrl;
        final title = product.productName ?? "Unknown Product";
        final brand = product.brands ?? "Unknown Brand";

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: imageUrl != null
                      ? Image.network(imageUrl, fit: BoxFit.cover)
                      : Container(
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: const Icon(Icons.fastfood, size: 40, color: Colors.grey),
                  ),
                ),
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black54,
                          Colors.transparent],
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        brand,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(product: product),
                        ),
                      );
                    },
                    child: const SizedBox(height: 180, width: double.infinity),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
