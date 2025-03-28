import 'package:flutter/material.dart';
// Replace this import with the actual path to your BloodSugarUtils file
import '../../utils/blood_sugar_utils.dart';

class BloodSugarDetailsScreen extends StatefulWidget {
  /// Mock data (replace with your real data when needed)
  final List<double> sugarTrend;
  final double targetMin;
  final double targetMax;

  const BloodSugarDetailsScreen({
    super.key,
    this.sugarTrend = const [90, 100, 110, 115, 120, 125, 130],
    this.targetMin = 80,
    this.targetMax = 140,
  });

  @override
  State<BloodSugarDetailsScreen> createState() =>
      _BloodSugarDetailsScreenState();
}

class _BloodSugarDetailsScreenState extends State<BloodSugarDetailsScreen> {
  bool _showAllRecords = false;

  double? get _minValue => widget.sugarTrend.isNotEmpty
      ? widget.sugarTrend.reduce((a, b) => a < b ? a : b)
      : null;

  double? get _maxValue => widget.sugarTrend.isNotEmpty
      ? widget.sugarTrend.reduce((a, b) => a > b ? a : b)
      : null;

  double? get _averageValue => widget.sugarTrend.isNotEmpty
      ? BloodSugarUtils.calculateAverage(widget.sugarTrend)
      : null;

  /// Progress value for the average reading
  double get _progressValue {
    if (_averageValue == null) return 0.0;
    return BloodSugarUtils.calculateProgress(
      _averageValue!,
      widget.targetMin,
      widget.targetMax,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Generate mock daily records
    final records = List.generate(
      widget.sugarTrend.length,
          (index) => {
        "day": "Day ${index + 1}",
        "value": widget.sugarTrend[index],
      },
    );

    // Show either all records or only the first 3
    final recordsToShow = _showAllRecords ? records : records.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Blood Sugar Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[200],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            /// Graph Placeholder
            _buildGraphPlaceholder(),

            const SizedBox(height: 16),

            /// Summary Row (Min, Avg, Max)
            _buildSummarySection(),

            const SizedBox(height: 16),

            /// Weekly Records
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildRecordsList(recordsToShow),
            ),
          ],
        ),
      ),
    );
  }

  /// Graph Placeholder Widget
  Widget _buildGraphPlaceholder() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
    );
  }

  /// Builds the summary section that shows Min, Avg, and Max
  Widget _buildSummarySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSummaryTile('Min', _minValue),
            _buildAverageTile(),
            _buildSummaryTile('Max', _maxValue),
          ],
        ),
      ),
    );
  }

  /// A single tile for Min or Max values
  Widget _buildSummaryTile(String label, double? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value != null ? value.toStringAsFixed(1) : '--',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '$label mg/dL',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  /// Specialized tile for Average reading with a progress bar
  Widget _buildAverageTile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _averageValue != null
              ? 'Avg. ${_averageValue!.toStringAsFixed(1)} mg/dL'
              : 'Avg. --',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.orange,
          ),
        ),
        const SizedBox(height: 8),
        _buildProgressBar(),
      ],
    );
  }

  /// Progress bar indicating how the average reading compares to the target range
  Widget _buildProgressBar() {
    return Container(
      height: 10,
      width: 150,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        children: [
          Positioned(
            left: (_progressValue * 150).clamp(0, 150) - 3,
            child: Container(
              height: 12,
              width: 6,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the list of daily records (showing a "View All" / "View Less" button)
  Widget _buildRecordsList(List<Map<String, dynamic>> recordsToShow) {
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
          ...recordsToShow.map((record) {
            return Column(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        record["day"],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${record["value"].toStringAsFixed(1)} mg/dL",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                // A thin divider between items
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  height: 16,
                ),
              ],
            );
          }),
          const SizedBox(height: 12),
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
