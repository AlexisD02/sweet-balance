import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import 'package:sweet_balance/ui/screens/meals_screen.dart';
import 'package:sweet_balance/ui/screens/notifications_screen.dart';
import 'package:sweet_balance/ui/screens/profile_screen.dart';
import 'package:sweet_balance/ui/screens/add_info_card_screen.dart';

import '../widgets/collapsible_header.dart';
import '../widgets/bottom_nav_menu.dart';
import '../widgets/infoCards/blood_sugar_info_card.dart';
import '../widgets/infoCards/insulin_calculator_info_card.dart';
import '../widgets/infoCards/carbohydrate_intake_info_card.dart';
import '../widgets/popup_menu.dart';

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
    const BloodSugarInfoCard(
      currentBloodSugar: 120.5,
      targetMin: 80,
      targetMax: 140,
      isEditMode: false,
    ),
    const InsulinCalculatorInfoCard(
      insulinDose: 5.0,
      carbIntake: 50,
      insulinSensitivityFactor: 40,
      targetBloodSugar: 100,
      isEditMode: false,
    ),
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
        // set NeverScrollableScrollPhysics().
        // physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          _buildHomePage,
          const MealsScreen(),
          const NotificationScreen(),
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
              title: _isEditMode ? "Edit Home" : "APP Name",
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
                const SizedBox(width: 2),
                const PopupMenuWidget(),
              ],
            ),
            ReorderableSliverList(
              enabled: _isEditMode,
              delegate: ReorderableSliverChildListDelegate(
                _infoCards.map((card) {
                  final index = _infoCards.indexOf(card);
                  if (card is BloodSugarInfoCard) {
                    return BloodSugarInfoCard(
                      currentBloodSugar: 120.5,
                      targetMin: 80,
                      targetMax: 140,
                      isEditMode: _isEditMode,
                      onRemove: _isEditMode ? () => _removeCard(index) : null,
                    );
                  } else if (card is InsulinCalculatorInfoCard) {
                    return InsulinCalculatorInfoCard(
                      insulinDose: 5.0,
                      carbIntake: 50,
                      insulinSensitivityFactor: 40,
                      targetBloodSugar: 100,
                      isEditMode: _isEditMode,
                      onRemove: _isEditMode ? () => _removeCard(index) : null,
                    );
                  } else if (card is CarbohydrateIntakeInfoCard) {
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
        if (_infoCards[i] is BloodSugarInfoCard) {
          _infoCards[i] = BloodSugarInfoCard(
            currentBloodSugar: 120.5,
            targetMin: 80,
            targetMax: 140,
            isEditMode: _isEditMode,
            onRemove: _isEditMode ? () => _removeCard(i) : null,
          );
        } else if (_infoCards[i] is InsulinCalculatorInfoCard) {
          _infoCards[i] = InsulinCalculatorInfoCard(
            insulinDose: 5.0,
            carbIntake: 50,
            insulinSensitivityFactor: 40,
            targetBloodSugar: 100,
            isEditMode: _isEditMode,
            onRemove: _isEditMode ? () => _removeCard(i) : null,
          );
        } else if (_infoCards[i] is CarbohydrateIntakeInfoCard) {
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
