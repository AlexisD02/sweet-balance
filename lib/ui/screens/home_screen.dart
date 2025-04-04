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

  int _currentIndex = 0; // Keeps track of the current page index
  bool _isEditMode = false; // Enables reorder/remove mode for cards

  List<Widget> _infoCards = []; // Cards currently visible on home screen
  final List<String> _removedKeys = []; // Tracks which cards have been removed

  @override
  void initState() {
    super.initState();
    _infoCards = _buildInitialCards(); // Initialize home with default cards
  }

  // Builds default cards to be shown on load
  List<Widget> _buildInitialCards() {
    return [
      _buildCard('sugar'),
      _buildCard('fat'),
      _buildCard('proteins'),
      _buildCard('energy'),
    ];
  }

  // Creates a specific widget from a given key
  Widget _buildCard(String keyName) {
    return NutrientStatCard(
      key: ValueKey(keyName),
      nutrientKey: _getNutrientKey(keyName),
      label: _getLabel(keyName),
      icon: _getIcon(keyName),
      color: _getColor(keyName),
      isEditMode: _isEditMode,
      onRemove: _isEditMode ? () => _removeCardByKey(keyName) : null,
    );
  }

  // Removes a card by its key and remembers it in _removedKeys
  void _removeCardByKey(String keyName) {
    setState(() {
      _infoCards.removeWhere((card) => (card.key as ValueKey).value == keyName);
      if (!_removedKeys.contains(keyName)) {
        _removedKeys.add(keyName);
      }
    });
  }

  // Toggles the editable mode and rebuilds cards with edit options
  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;

      // Rebuild all cards to reflect new edit mode status
      _infoCards = _infoCards.map((widget) {
        final key = widget.key;
        if (key is ValueKey<String>) {
          return _buildCard(key.value);
        }
        return widget;
      }).toList();
    });
  }

  // User can reorder cards when dragged around
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      final item = _infoCards.removeAt(oldIndex);
      _infoCards.insert(newIndex, item);
    });
  }

  // Navigates to add cards screen, for the selection of adding new cards
  void _navigateToNewScreen() async {
    final addedKeys = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(
        builder: (context) => AddInfoCard(removedCardKeys: _removedKeys),
      ),
    );

    // Add only cards that are not already on screen
    if (addedKeys != null && addedKeys.isNotEmpty) {
      setState(() {
        for (final key in addedKeys) {
          if (!_infoCards.any((card) => card.key == ValueKey(key))) {
            _infoCards.add(_buildCard(key));
            _removedKeys.remove(key);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
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

  // Main scrollable content for the home screen
  Widget get _buildHomePage {
    return Container(
      color: Colors.grey[200],
      child: CustomScrollView(
        slivers: [
          // Collapsible header bar with toggle/edit button
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
              const SizedBox(width: 10),
            ],
          ),

          // Allows drag-and-drop to reorder the info cards
          ReorderableSliverList(
            enabled: _isEditMode,
            delegate: ReorderableSliverChildListDelegate(_infoCards),
            onReorder: _isEditMode ? _onReorder : (_, __) {},
          ),
        ],
      ),
    );
  }

  // Mapping keys to OpenFoodFacts nutrient fields
  String _getNutrientKey(String keyName) {
    switch (keyName) {
      case 'sugar':
        return 'sugars';
      case 'fat':
        return 'fat';
      case 'proteins':
        return 'proteins';
      case 'energy':
        return 'energyKCal';
      default:
        return '';
    }
  }

  // User-facing labels for each nutrient info card
  String _getLabel(String keyName) {
    switch (keyName) {
      case 'sugar':
        return 'Sugar Intake';
      case 'fat':
        return 'Fat Intake';
      case 'proteins':
        return 'Protein Intake';
      case 'energy':
        return 'Calories';
      default:
        return '';
    }
  }

  // Icon that best represents each nutrient for info card
  IconData _getIcon(String keyName) {
    switch (keyName) {
      case 'sugar':
        return Icons.cake_outlined;
      case 'fat':
        return Icons.local_pizza_outlined;
      case 'proteins':
        return Icons.fitness_center;
      case 'energy':
        return Icons.local_fire_department;
      default:
        return Icons.info_outline;
    }
  }

  // Colour to visually distinguish the info card
  Color _getColor(String keyName) {
    switch (keyName) {
      case 'sugar':
        return Colors.teal;
      case 'fat':
        return Colors.deepOrange;
      case 'proteins':
        return Colors.purple;
      case 'energy':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }
}
