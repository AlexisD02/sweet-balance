import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';

import 'package:sweet_balance/ui/screens/meals_screen.dart';
import 'package:sweet_balance/ui/screens/profile_screen.dart';
import 'package:sweet_balance/ui/screens/add_info_card_screen.dart';

import '../widgets/collapsible_header.dart';
import '../widgets/bottom_nav_menu.dart';
import '../widgets/infoCards/carbohydrate_intake_info_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  int _currentIndex = 0;
  bool _isEditMode = false;

  final List<Widget> _infoCards = [
    const CarbohydrateIntakeInfoCard(
      dailyIntake: 150,
      targetIntake: 200,
      isEditMode: false,
    ),
    const CarbohydrateIntakeInfoCard(
      dailyIntake: 150,
      targetIntake: 200,
      isEditMode: false,
    ),
  ];

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
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 100000000),
      child: Container(
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
                  child: const Icon(
                    Icons.add,
                    size: 30.0,
                  ),
                ),
              ] : [
                GestureDetector(
                  onTap: _toggleEditMode,
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 26.0,
                  ),
                ),
                const SizedBox(width: 10, height: 40),
              ],
            ),
            ReorderableSliverList(
              enabled: _isEditMode,
              delegate: ReorderableSliverChildListDelegate(
                _infoCards.map((card) {
                  final index = _infoCards.indexOf(card);
                  if (card is CarbohydrateIntakeInfoCard) {
                    return CarbohydrateIntakeInfoCard(
                      dailyIntake: 150,
                      targetIntake: 200,
                      isEditMode: _isEditMode,
                      onRemove: _isEditMode ? () => _removeCard(index) : null,
                    );
                  }
                  return card;
                }).toList(),
              ),
              onReorder: _isEditMode ? _onReorder : (_, __) {},
            ),
          ],
        ),
      ),
    );
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;

      for (int i = 0; i < _infoCards.length; i++) {
        if (_infoCards[i] is CarbohydrateIntakeInfoCard) {
          _infoCards[i] = CarbohydrateIntakeInfoCard(
            dailyIntake: 150,
            targetIntake: 200,
            isEditMode: _isEditMode,
            onRemove: _isEditMode ? () => _removeCard(i) : null,
          );
        }
      }
    });
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
