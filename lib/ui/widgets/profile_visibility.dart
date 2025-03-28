import 'package:flutter/material.dart';

class ProfileVisibilityCard extends StatelessWidget {
  const ProfileVisibilityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showVisibilityOptions(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Row(
            children: [
              Icon(
                Icons.visibility_outlined,
                size: 28,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 15),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile Visibility',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Friends Only',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVisibilityOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          title: const Text(
            'Select Profile Visibility',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                    Icons.public,
                    color: Colors.blue,
                    size: 30.0,
                ),
                title: const Text('Public'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 5.0),

              ListTile(
                leading: const Icon(
                    Icons.group,
                    color: Colors.green,
                    size: 30.0,
                ),
                title: const Text('Friends Only'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 5.0),

              ListTile(
                leading: const Icon(
                    Icons.lock,
                    color: Colors.red,
                    size: 30.0,
                ),
                title: const Text('Private'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
