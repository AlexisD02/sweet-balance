import 'package:flutter/material.dart';

class CustomInfoCard extends StatelessWidget {
  final double height;
  final bool isEditMode;
  final VoidCallback? onRemove;

  const CustomInfoCard({
    super.key,
    required this.height,
    this.isEditMode = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              'Info Card',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
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
    );
  }
}
