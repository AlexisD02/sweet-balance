import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String time;
  final String dateLabel;

  final bool isEditMode;
  final VoidCallback? onRemove;

  const NotificationCard({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
    this.dateLabel = '',
    this.isEditMode = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (dateLabel.isNotEmpty)
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20, top: 10, bottom: 5),
            child: Text(
              dateLabel,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        icon,
                        size: 32,
                        color: _getIconColor(icon),
                      ),
                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),

                            Text(
                              message,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),

                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                time,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (isEditMode && onRemove != null)
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onRemove,
                    child: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.red,
                      size: 28,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getIconColor(IconData icon) {
    if (icon == Icons.warning_amber_rounded) {
      return Colors.orange;
    } else if (icon == Icons.check_circle_outline) {
      return Colors.green;
    } else if (icon == Icons.info_outline) {
      return Colors.blue;
    } else {
      return Colors.grey;
    }
  }
}
