import 'package:flutter/material.dart';

class InsulinCalculatorDetailScreen extends StatefulWidget {
  final double insulinDose;
  final double carbIntake;
  final double insulinSensitivityFactor;
  final double targetBloodSugar;

  // Example weekly records
  final List<Map<String, dynamic>> weeklyRecords = [
    {"day": "Mon", "dose": 12.5},
    {"day": "Tue", "dose": 10.2},
    {"day": "Wed", "dose": 14.0},
    {"day": "Thu", "dose": 11.5},
    {"day": "Fri", "dose": 9.8},
    {"day": "Sat", "dose": 13.4},
    {"day": "Sun", "dose": 12.7},
  ];

  InsulinCalculatorDetailScreen({
    super.key,
    required this.insulinDose,
    required this.carbIntake,
    required this.insulinSensitivityFactor,
    required this.targetBloodSugar,
  });

  @override
  _InsulinCalculatorDetailScreenState createState() => _InsulinCalculatorDetailScreenState();
}

class _InsulinCalculatorDetailScreenState extends State<InsulinCalculatorDetailScreen> {
  bool _showAllRecords = false;

  @override
  Widget build(BuildContext context) {
    final double averageDose = _calculateAverageDose(widget.weeklyRecords);
    final double maxDose = _calculateMaxDose(widget.weeklyRecords);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Insulin Calculator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[200],
        child: ListView(
          padding: EdgeInsets.zero, // Removed padding for the entire ListView
          children: [
            // Graph Placeholder
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "Graph Placeholder",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Statistics Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard("Avg Dose", "${averageDose.toStringAsFixed(1)} U"),
                  _buildStatCard("Max Dose", "${maxDose.toStringAsFixed(1)} U"),
                  _buildStatCard("Target", "${widget.targetBloodSugar.toStringAsFixed(0)} mg/dL"),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Weekly Records
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildRecordsList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a stat card for Avg Dose, Max Dose, etc.
  Widget _buildStatCard(String label, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a list of weekly insulin records
  Widget _buildRecordsList() {
    List<Map<String, dynamic>> recordsToShow = _showAllRecords
        ? widget.weeklyRecords
        : widget.weeklyRecords.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...recordsToShow.asMap().entries.map((entry) {
            final Map<String, dynamic> record = entry.value;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dose (top-left)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${record["dose"].toStringAsFixed(1)} U",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Day (left side on second row)
                          Text(
                            "${record["day"]}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      // Icon (top-right)
                      const Icon(
                        Icons.local_hospital_outlined,
                        size: 24,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.black26,
                  thickness: 0.8,
                  height: 16,
                ),
              ],
            );
          }),
          Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  _showAllRecords = !_showAllRecords;
                });
              },
              child: Text(
                _showAllRecords ? "View Less" : "View All",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Calculate the average dose from weekly records
  double _calculateAverageDose(List<Map<String, dynamic>> records) {
    if (records.isEmpty) return 0.0;
    final total = records.fold(0.0, (sum, record) => sum + record["dose"]);
    return total / records.length;
  }

  /// Calculate the max dose from weekly records
  double _calculateMaxDose(List<Map<String, dynamic>> records) {
    if (records.isEmpty) return 0.0;
    return records.map((record) => record["dose"] as double).reduce((a, b) => a > b ? a : b);
  }
}
