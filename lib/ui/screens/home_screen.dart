import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';

import 'package:sweet_balance/ui/screens/meals_screen.dart';
import 'package:sweet_balance/ui/screens/profile_screen.dart';
import 'package:sweet_balance/ui/screens/add_info_card_screen.dart';

import '../widgets/collapsible_header.dart';
import '../widgets/bottom_nav_menu.dart';
import '../widgets/infoCards/nutrient_stat_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _isEditMode = false;

  List<Widget> _infoCards = [];

  @override
  void initState() {
    super.initState();
    _infoCards = _buildInitialCards();
  }

  List<Widget> _buildInitialCards() {
    return [
      NutrientStatCard(
        key: const ValueKey('sugar'),
        nutrientKey: 'sugars',
        label: 'Sugar Intake',
        icon: Icons.cake_outlined,
        color: Colors.teal,
        isEditMode: _isEditMode,
        onRemove: _isEditMode ? () => _removeCard(0) : null,
      ),
      NutrientStatCard(
        key: const ValueKey('fat'),
        nutrientKey: 'fat',
        label: 'Fat Intake',
        icon: Icons.local_pizza_outlined,
        color: Colors.deepOrange,
        isEditMode: _isEditMode,
        onRemove: _isEditMode ? () => _removeCard(1) : null,
      ),
      NutrientStatCard(
        key: const ValueKey('proteins'),
        nutrientKey: 'proteins',
        label: 'Protein Intake',
        icon: Icons.fitness_center,
        color: Colors.purple,
        isEditMode: _isEditMode,
        onRemove: _isEditMode ? () => _removeCard(2) : null,
      ),
      NutrientStatCard(
        key: const ValueKey('energy'),
        nutrientKey: 'energyKCal',
        label: 'Calories',
        icon: Icons.local_fire_department,
        color: Colors.redAccent,
        isEditMode: _isEditMode,
        onRemove: _isEditMode ? () => _removeCard(3) : null,
      ),
    ];
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;

      for (int i = 0; i < _infoCards.length; i++) {
        final card = _infoCards[i];
        if (card.key is String) {
          final keyName = (card.key as String);
          _infoCards[i] = _buildCardFromKey(keyName, i);
        }
      }
    });
  }

  Widget _buildCardFromKey(String keyName, int index) {
    switch (keyName) {
      case 'sugar':
        return NutrientStatCard(
          key: const ValueKey('sugar'),
          nutrientKey: 'sugars',
          label: 'Sugar Intake',
          icon: Icons.cake_outlined,
          color: Colors.teal,
          isEditMode: _isEditMode,
          onRemove: _isEditMode ? () => _removeCard(index) : null,
        );
      case 'fat':
        return NutrientStatCard(
          key: const ValueKey('fat'),
          nutrientKey: 'fat',
          label: 'Fat Intake',
          icon: Icons.local_pizza_outlined,
          color: Colors.deepOrange,
          isEditMode: _isEditMode,
          onRemove: _isEditMode ? () => _removeCard(index) : null,
        );
      case 'proteins':
        return NutrientStatCard(
          key: const ValueKey('proteins'),
          nutrientKey: 'proteins',
          label: 'Protein Intake',
          icon: Icons.fitness_center,
          color: Colors.purple,
          isEditMode: _isEditMode,
          onRemove: _isEditMode ? () => _removeCard(index) : null,
        );
      case 'energy':
        return NutrientStatCard(
          key: const ValueKey('energy'),
          nutrientKey: 'energyKCal',
          label: 'Calories',
          icon: Icons.local_fire_department,
          color: Colors.redAccent,
          isEditMode: _isEditMode,
          onRemove: _isEditMode ? () => _removeCard(index) : null,
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          _buildHomePage,
          const MealsScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavMenu(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }

  Widget get _buildHomePage {
    return Container(
      color: Colors.grey[200],
      child: CustomScrollView(
        slivers: [
          CollapsibleHeader(
            title: _isEditMode ? "Edit Home" : "Sweet Balance",
            isEditMode: _isEditMode,
            onBackPressed: _toggleEditMode,
            actions: _isEditMode
                ? [
              GestureDetector(
                onTap: _navigateToNewScreen,
                child: const Icon(Icons.add, size: 30.0),
              ),
            ]
                : [
              GestureDetector(
                onTap: _toggleEditMode,
                child: const Icon(Icons.edit_outlined, size: 26.0),
              ),
              const SizedBox(width: 10, height: 40),
            ],
          ),
          ReorderableSliverList(
            enabled: _isEditMode,
            delegate: ReorderableSliverChildListDelegate(
              _infoCards,
            ),
            onReorder: _isEditMode ? _onReorder : (_, __) {},
          ),
        ],
      ),
    );
  }

  void _navigateToNewScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddInfoCard(),
      ),
    );
  }

  void _removeCard(int index) {
    setState(() {
      _infoCards.removeAt(index);
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      final item = _infoCards.removeAt(oldIndex);
      _infoCards.insert(newIndex, item);
    });
  }
}
