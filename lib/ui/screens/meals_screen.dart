import 'package:flutter/material.dart';
import 'package:sweet_balance/ui/screens/search_screen.dart';
import 'package:sweet_balance/ui/widgets/plan_meals_section.dart';

import '../widgets/collapsible_header.dart';
import '../widgets/infoCards/recipes_info_card.dart';
import '../widgets/popup_menu.dart';
import '../widgets/quick_recipes_categories.dart';

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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          CollapsibleHeader(
            title: "Meals",
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchScreen()),
                  );
                },
                child: const Icon(
                  Icons.search_outlined,
                  size: 26.0,
                ),
              ),
              const SizedBox(width: 13.0),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return const Placeholder();
                    },
                  );
                },
                child: const Icon(
                  Icons.filter_list_outlined,
                  size: 26.0,
                ),
              ),
              const PopupMenuWidget(),
            ],
          ),
          const SliverToBoxAdapter(
            child: PlanMealsCardInfo(),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 5),
          ),

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Text(
                'Quick Recipes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: QuickRecipesCategories(),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 5),
          ),


          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Text(
                'Premium Recipes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: RecipesInfoCard(
              title: 'Newest Recipes',
              items: [
                {'title': 'Pasta'},
                {'title': 'Salad'},
                {'title': 'Burger'},
              ],
            ),
          ),
          const SliverToBoxAdapter(
            child: RecipesInfoCard(
              title: 'Trending Recipes',
              items: [
                {'title': 'Pizza'},
                {'title': 'Sushi'},
                {'title': 'Tacos'},
              ],
            ),
          ),
          const SliverToBoxAdapter(
            child: RecipesInfoCard(
              title: 'Budget-Friendly Recipes',
              items: [
                {'title': 'Sandwich'},
                {'title': 'Soup'},
                {'title': 'Rice Bowl'},
              ],
            ),
          ),
        ],
      ),
    );
  }
}
