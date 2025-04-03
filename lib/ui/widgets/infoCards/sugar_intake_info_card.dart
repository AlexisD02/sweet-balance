import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:sweet_balance/ui/screens/info_tracking_screen.dart';

class DailySugarIntakeCard extends StatefulWidget {
  final bool isEditMode;
  final VoidCallback? onRemove;

  const DailySugarIntakeCard({
    super.key,
    this.isEditMode = false,
    this.onRemove,
  });

  @override
  State<DailySugarIntakeCard> createState() => _DailySugarIntakeCardState();
}

class _DailySugarIntakeCardState extends State<DailySugarIntakeCard> {
  double _todaySugar = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSugarData();
  }

  Future<void> _fetchSugarData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final query = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tracker')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
        .get();

    double totalSugar = 0;
    final ids = <String>[];

    for (final doc in query.docs) {
      final sugar = doc['sugars'];
      if (sugar is num) {
        totalSugar += sugar.toDouble();
        ids.add(doc.id);
      }
    }

    setState(() {
      _todaySugar = totalSugar;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWithinTarget = _todaySugar <= 25;
    final progress = (_todaySugar / 25).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.teal,
                      ),
                      child: const Icon(
                        Icons.cake_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Sugar Intake",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _todaySugar.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                        color: isWithinTarget ? Colors.teal : Colors.redAccent,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text(
                        "g",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "Target: 25",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 10,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            Positioned(
                              left: (progress * 150) - 3,
                              child: Container(
                                height: 12,
                                width: 6,
                                decoration: BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SugarIntakeDetailScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.teal, width: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  ),
                  child: const Text(
                    "View Details",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (widget.isEditMode && widget.onRemove != null)
            Positioned(
              top: 10,
              right: 10,
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
