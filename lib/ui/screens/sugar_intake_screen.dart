import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SugarIntakeDetailScreen extends StatefulWidget {
  const SugarIntakeDetailScreen({super.key});

  @override
  State<SugarIntakeDetailScreen> createState() => _SugarIntakeDetailScreenState();
}

class _SugarIntakeDetailScreenState extends State<SugarIntakeDetailScreen> {
  bool _showAll = false;
  bool _isLoading = true;

  List<Map<String, dynamic>> _dayWiseData = [];

  @override
  void initState() {
    super.initState();
    _loadSugarData();
  }

  Future<void> _loadSugarData() async {
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

      double dailySugar = 0;
      List<Map<String, dynamic>> products = [];

      for (final doc in query.docs) {
        final data = doc.data();
        if (data['sugars'] != null && data['sugars'] is num) {
          final sugar = (data['sugars'] as num).toDouble();
          dailySugar += sugar;
          if (data['name'] != null) {
            products.add({
              'name': data['name'],
              'sugars': sugar,
            });
          }
        }
      }

      if (dailySugar > 0) {
        tempData.add({
          "day": "${start.month}/${start.day}",
          "value": dailySugar,
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
        title: const Text('Sugar Intake Details'),
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
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
    final maxValue = _dayWiseData.map((e) => e['value'] as double).reduce(max);
    final interval = calculateInterval(maxValue);
    final roundedMax = calculateRoundedMax(maxValue, interval);

    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final day = _dayWiseData[group.x.toInt()]['day'];
                final value = rod.toY.toStringAsFixed(1);
                return BarTooltipItem(
                  '$day\n$value g',
                  const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false,
            horizontalInterval: interval,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey[300],
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: interval,
                getTitlesWidget: (value, meta) {
                  if (value % interval == 0) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.black54),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
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
                  color: Colors.blueAccent,
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
                  trailing: Text('${product['sugars'].toStringAsFixed(1)} g'),
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
            final double sugar = e['value'] ?? 0;
            final String day = e['day'] ?? '';
            final List<Map<String, dynamic>> products = List<Map<String, dynamic>>.from(e['products'] ?? []);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _showProductDetails(day, products),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${sugar.toStringAsFixed(1)} g',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.teal,
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
                    products
                        .map((p) =>
                    (p['name'] != null && p['name'].toString().trim().isNotEmpty)
                        ? p['name']
                        : (p['brand'] ?? 'Unknown'))
                        .join(', '),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                const Divider(height: 16),
              ],
            );
          }),
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
