import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class NutrientDetailScreen extends StatefulWidget {
  final String nutrientKey;
  final String label;
  final Color color;

  const NutrientDetailScreen({
    super.key,
    required this.nutrientKey,
    required this.label,
    required this.color,
  });

  @override
  State<NutrientDetailScreen> createState() => _NutrientDetailScreenState();
}

class _NutrientDetailScreenState extends State<NutrientDetailScreen> {
  bool _showAll = false;
  bool _isLoading = true;
  List<Map<String, dynamic>> _dayWiseData = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final now = DateTime.now();
    final last7Days = List.generate(7, (i) => now.subtract(Duration(days: 6 - i)));
    List<Map<String, dynamic>> tempData = [];

    for (final day in last7Days) {
      final start = DateTime(day.year, day.month, day.day);
      final end = start.add(const Duration(days: 1));

      final query = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tracker')
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('timestamp', isLessThan: Timestamp.fromDate(end))
          .get();

      double dailyValue = 0;
      List<Map<String, dynamic>> products = [];

      for (final doc in query.docs) {
        final data = doc.data();
        final value = data[widget.nutrientKey];

        if (value is num) {
          dailyValue += value.toDouble();
          if (data['name'] != null) {
            products.add({
              'name': data['name'],
              'value': value,
            });
          }
        }
      }

      if (dailyValue > 0) {
        tempData.add({
          "day": "${start.month}/${start.day}",
          "value": dailyValue,
          "products": products,
        });
      }
    }

    setState(() {
      _dayWiseData = tempData;
      _isLoading = false;
    });
  }

  double calculateInterval(double maxValue, {int targetTickCount = 5}) {
    if (maxValue <= 0) return 1;
    final roughInterval = maxValue / targetTickCount;
    final magnitude = pow(10, (log(roughInterval) / ln10).floor());
    final residual = roughInterval / magnitude;

    double niceResidual;
    if (residual < 1.5) {
      niceResidual = 1;
    } else if (residual < 3) {
      niceResidual = 2;
    } else if (residual < 7) {
      niceResidual = 5;
    } else {
      niceResidual = 10;
    }

    return niceResidual * magnitude;
  }

  double calculateRoundedMax(double maxValue, double interval) {
    return (maxValue / interval).ceil() * interval;
  }

  @override
  Widget build(BuildContext context) {
    final shownData = _showAll ? _dayWiseData : _dayWiseData.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.label} Details'),
        backgroundColor: Colors.grey[100],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _dayWiseData.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            "No data available for ${widget.label}.",
            style: const TextStyle(fontSize: 18, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ),
      )
          : Container(
        color: Colors.grey[200],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildBarGraph(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildHistory(shownData),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarGraph() {
    if (_dayWiseData.isEmpty) return const SizedBox.shrink();

    final maxValue = _dayWiseData.map((e) => e['value'] as double).reduce(max);
    final interval = calculateInterval(maxValue);
    final roundedMax = calculateRoundedMax(maxValue, interval);

    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, _, rod, __) {
                final day = _dayWiseData[group.x.toInt()]['day'];
                final value = rod.toY.toStringAsFixed(1);
                return BarTooltipItem(
                  '$day\n$value g',
                  const TextStyle(fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            horizontalInterval: interval,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(
              color: Colors.grey[300],
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: interval,
                getTitlesWidget: (value, _) {
                  if (value % interval == 0) {
                    return Text(value.toInt().toString(),
                        style: const TextStyle(fontSize: 10, color: Colors.black54));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  int i = value.toInt();
                  if (i < 0 || i >= _dayWiseData.length) return const Text('');
                  return Text(_dayWiseData[i]['day'], style: const TextStyle(fontSize: 10));
                },
              ),
            ),
          ),
          maxY: roundedMax,
          barGroups: _dayWiseData.asMap().entries.map((e) {
            final index = e.key;
            final value = e.value['value'] ?? 0.0;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: value,
                  width: 16,
                  borderRadius: BorderRadius.circular(6),
                  color: widget.color,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showProductDetails(String day, List<Map<String, dynamic>> products) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Products for $day",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (products.isEmpty)
                const Text("No products tracked on this day."),
              ...products.map(
                    (product) => ListTile(
                  leading: const Icon(Icons.fastfood),
                  title: Text(product['name'] ?? 'Unnamed'),
                  trailing: Text('${product['value'].toStringAsFixed(1)} g'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistory(List<Map<String, dynamic>> shownData) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...shownData.map((e) {
            final double value = e['value'] ?? 0;
            final String day = e['day'] ?? '';
            final List<Map<String, dynamic>> products =
            List<Map<String, dynamic>>.from(e['products'] ?? []);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _showProductDetails(day, products),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${value.toStringAsFixed(1)} g',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: widget.color,
                        ),
                      ),
                      Text(
                        day,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                if (products.isNotEmpty)
                  Text(
                    products.map((p) => p['name'] ?? 'Unknown').join(', '),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                const Divider(height: 16),
              ],
            );
          }),
          if (_dayWiseData.length > 3)
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _showAll = !_showAll;
                  });
                },
                child: Text(
                  _showAll ? 'View Less' : 'View All',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
