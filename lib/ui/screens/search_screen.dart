import 'dart:async'; // Timer is used for debouncing the search input
import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import '../widgets/search_field.dart';
import 'product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final SortOption initialSort;
  final String? initialCategoryFilter;

  const SearchScreen({
    super.key,
    this.initialSort = SortOption.POPULARITY, // Default to most popular results
    this.initialCategoryFilter, // Used when we want to pre-filter by category
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

    // Load initial sort and category from passed arguments
    _sortOption = widget.initialSort;

    if (widget.initialCategoryFilter != null) {
      _selectedCategories = [widget.initialCategoryFilter!];
    }

    // Fetch product list on load
    _fetchProducts();
  }

  @override
  void dispose() {
    _debounce?.cancel(); // Clean up the debounce timer
    super.dispose();
  }

  // Debounce to avoid calling the API on every keystroke
  void _onSearchChanged(String query) {
    setState(() => _searchQuery = query);

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), _fetchProducts);
  }

  void _onCategoryChanged(List<String> selected) {
    setState(() {
      _selectedCategories = selected; // Update filters
    });
    _fetchProducts(); // Refetch with new filters
  }

  // Fetch products from OpenFoodFacts API based on search and filters
  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final parameters = <Parameter>[
        const PageSize(size: 20),
        SortBy(option: _sortOption), // Respect current sort setting
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

      // Only keep products that have meaningful nutritional info
      final filtered = result.products?.where((p) {
        final n = p.nutriments;
        return n?.getValue(Nutrient.energyKCal, PerSize.oneHundredGrams) != null ||
            n?.getValue(Nutrient.sugars, PerSize.oneHundredGrams) != null ||
            n?.getValue(Nutrient.fat, PerSize.oneHundredGrams) != null;
      }).toList();

      setState(() {
        _products = filtered ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  // Bottom sheet filter UI for category selection
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
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        final tempSelected = [..._selectedCategories];
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Filter by Category',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        // Display each category as a checkbox
                        ...allCategories.map((category) {
                          final capitalized = category[0].toUpperCase() + category.substring(1).replaceAll('-', ' ');
                          return CheckboxListTile(
                            value: tempSelected.contains(category),
                            title: Text(capitalized),
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
                      ],
                    ),
                  ),
                  // "Apply Filter" button fixed at bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.95),
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
                          onPressed: () {
                            Navigator.pop(context);
                            _onCategoryChanged(tempSelected);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Apply Filter',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
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
                // Background image or placeholder
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
                // Gradient overlay for readability
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black.withAlpha(120),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // Product name and brand text
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

                // Full clickable area to open product detail
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
