import 'dart:async';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import '../widgets/search_field.dart';
import 'product_detail_screen.dart';

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
  List<String> _selectedCategories = [];
  bool _isLoading = false;
  bool _hasError = false;
  Timer? _debounce;
  late SortOption _sortOption;

  @override
  void initState() {
    super.initState();
    _sortOption = widget.initialSort;
    _fetchProducts();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() => _searchQuery = query);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), _fetchProducts);
  }

  void _onCategoryChanged(List<String> selected) {
    setState(() {
      _selectedCategories = selected;
    });
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final parameters = <Parameter>[
        const PageSize(size: 20),
        SortBy(option: _sortOption),
        if (_searchQuery.trim().isNotEmpty)
          SearchTerms(terms: [_searchQuery]),
        for (final category in _selectedCategories)
          TagFilter.fromType(
            tagFilterType: TagFilterType.CATEGORIES,
            tagName: category,
          ),
      ];

      final config = ProductSearchQueryConfiguration(
        language: OpenFoodFactsLanguage.ENGLISH,
        version: ProductQueryVersion.v3,
        parametersList: parameters,
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
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _showCategoryFilterSheet() {
    final allCategories = [
      'drinks',
      'meals',
      'snacks',
      'breakfasts',
      'fruit-based-beverages',
      'sweets',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        final tempSelected = [..._selectedCategories];
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Filter by Category',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...allCategories.map((category) {
                    return CheckboxListTile(
                      value: tempSelected.contains(category),
                      title: Text(category.replaceAll('-', ' ').toUpperCase()),
                      onChanged: (bool? checked) {
                        setModalState(() {
                          if (checked == true) {
                            tempSelected.add(category);
                          } else {
                            tempSelected.remove(category);
                          }
                        });
                      },
                    );
                  }),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _onCategoryChanged(tempSelected);
                    },
                    child: const Text('Apply Filter'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        titleSpacing: 10,
        title: SearchField(
          placeholder: 'Search for a product...',
          onChanged: _onSearchChanged,
          onOpenFilter: _showCategoryFilterSheet,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
          ? const Center(child: Text('An error occurred'))
          : _products.isEmpty
          ? const Center(child: Text('No results found.'))
          : _buildProductList(),
    );
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
                      colors: [Colors.black54, Colors.transparent],
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
