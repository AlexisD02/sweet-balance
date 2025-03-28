import 'package:flutter/material.dart';

import '../screens/promotions_screen.dart';
import '../screens/settings_screen.dart';

class PopupMenuWidget extends StatelessWidget {
  const PopupMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'Promotions') {
          // Navigate to PromotionsScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PromotionsScreen(),
            ),
          );
        } else if (value == 'Settings') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsScreen(),
            ),
          );
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'Promotions',
            child: Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text('Promotions'),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'Settings',
            child: Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text('Settings'),
            ),
          ),
        ];
      },
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      constraints: const BoxConstraints(
        minWidth: 150,
      ),
      icon: const Icon(
        Icons.more_vert,
        size: 26.0,
      ),
    );
  }
}
