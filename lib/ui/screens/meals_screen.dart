import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

import 'package:sweet_balance/ui/screens/search_screen.dart';
import 'package:sweet_balance/ui/widgets/plan_meals_section.dart';

import '../widgets/collapsible_header.dart';
import '../widgets/infoCards/products_info_card.dart';
import '../widgets/quick_product_categories.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(250.0);
    });
  }

  // Fetch a list of products from OpenFoodFacts using a given sort option.
  Future<List<Product>> fetchProducts({
    required SortOption sortOption,
    int pageSize = 5,
  }) async {
    final config = ProductSearchQueryConfiguration(
      version: ProductQueryVersion.v3,
      language: OpenFoodFactsLanguage.ENGLISH,
      parametersList: [
        PageSize(size: pageSize),
        SortBy(option: sortOption),
      ],
      fields: [
        ProductField.NAME,
        ProductField.BRANDS,
        ProductField.IMAGE_FRONT_URL,
      ],
    );

    final result = await OpenFoodAPIClient.searchProducts(
      const User(userId: '0', password: ''), // anonymous user for public search
      config,
    );

    return result.products ?? [];
  }

  Widget buildProductSection(String title, SortOption sortOption) {
    return SliverToBoxAdapter(
      child: FutureBuilder<List<Product>>(
        future: fetchProducts(sortOption: sortOption),
        builder: (context, snapshot) {
          return ProductsInfoCard(
            title: title,
            products: snapshot.data ?? [],
            isLoading: snapshot.connectionState == ConnectionState.waiting,
            sortOption: sortOption,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Collapsible header with title and search icon
          CollapsibleHeader(
            title: "Meals",
            actions: [
              GestureDetector(
                onTap: () {
                  // Navigate to search screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchScreen()),
                  );
                },
                child: const Icon(Icons.search_outlined, size: 28.0),
              ),
              const SizedBox(width: 13.0, height: 45.0),
            ],
          ),

          // Favourites, quick meal plan, print/upload, upload product actions
          const SliverToBoxAdapter(child: PlanMealsCardInfo()),
          const SliverToBoxAdapter(child: SizedBox(height: 5)),

          // Show header for quick filter product categories
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Text(
                'Quick Filter Products',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Show categories of products
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: QuickProductsCategories(),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 10)),

          // Premium product header
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Text(
                'Premium Products',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Dynamically loaded product sections
          buildProductSection('Newest Products', SortOption.CREATED),
          buildProductSection('Popular Products', SortOption.POPULARITY),
          buildProductSection('Eco-Friendly Products', SortOption.ECOSCORE),
        ],
      ),
    );
  }
}
