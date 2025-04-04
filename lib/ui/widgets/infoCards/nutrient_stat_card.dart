import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../screens/info_tracking_screen.dart';

class NutrientStatCard extends StatefulWidget {
  final String nutrientKey;
  final String label;
  final IconData icon;
  final Color color;
  final bool isEditMode;
  final VoidCallback? onRemove;

  const NutrientStatCard({
    super.key,
    required this.nutrientKey,
    required this.label,
    required this.icon,
    required this.color,
    this.isEditMode = false,
    this.onRemove,
  });

  @override
  State<NutrientStatCard> createState() => _NutrientStatCardState();
}

class _NutrientStatCardState extends State<NutrientStatCard> {
  double _total = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNutrientData();
  }

  Future<void> _fetchNutrientData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final query = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tracker')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
        .get();

    double total = 0;

    for (final doc in query.docs) {
      final value = doc[widget.nutrientKey];
      if (value is num) {
        total += value.toDouble();
      }
    }

    setState(() {
      _total = total;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color,
                    ),
                    child: Icon(
                      widget.icon,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.label,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        "Daily Total",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_total.toStringAsFixed(1)} g',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: widget.color,
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NutrientDetailScreen(
                            nutrientKey: widget.nutrientKey,
                            label: widget.label,
                            color: widget.color,
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: widget.color, width: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                    ),
                    child: Text(
                      "View Details",
                      style: TextStyle(
                        fontSize: 14,
                        color: widget.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          if (widget.isEditMode && widget.onRemove != null)
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: widget.onRemove,
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
