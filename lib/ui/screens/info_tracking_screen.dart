import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SugarIntakeDetailScreen extends StatefulWidget {
  const SugarIntakeDetailScreen({super.key});

  @override
  State<SugarIntakeDetailScreen> createState() => _SugarIntakeDetailScreenState();
}

class _SugarIntakeDetailScreenState extends State<SugarIntakeDetailScreen> {
  bool _showAll = false;
  List<Map<String, dynamic>> _dayWiseData = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final now = DateTime.now();
    final last7Days = List.generate(7, (index) {
      final day = now.subtract(Duration(days: 6 - index));
      return DateTime(day.year, day.month, day.day);
    });

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tracker')
        .orderBy('timestamp', descending: true)
        .get();

    Map<String, double> sugarMap = {};
    Map<String, String> productMap = {};

    for (var day in last7Days) {
      final key = '${day.month}/${day.day}';
      sugarMap[key] = 0;
    }

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final timestamp = (data['timestamp'] as Timestamp?)?.toDate();
      final sugar = (data['sugars'] ?? 0).toDouble();
      final name = data['name'] ?? '';

      if (timestamp != null) {
        final date = DateTime(timestamp.year, timestamp.month, timestamp.day);
        final key = '${date.month}/${date.day}';
        if (sugarMap.containsKey(key)) {
          sugarMap[key] = (sugarMap[key] ?? 0) + sugar;
          productMap[key] = name;
        }
      }
    }

    _dayWiseData = sugarMap.entries.map((e) {
      return {
        'day': e.key,
        'value': e.value,
        'product': productMap[e.key] ?? '',
      };
    }).toList();

    setState(() {
      _loading = false;
    });
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Container(
        color: Colors.grey[200],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildGraph(),
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

  Widget _buildGraph() {
    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipPadding: EdgeInsets.zero,
              tooltipMargin: 0,
              getTooltipItem: (_, __, ___, ____) => null,
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int i = value.toInt();
                  if (i < 0 || i >= _dayWiseData.length) return const Text('');
                  return Text(
                    _dayWiseData[i]['day'],
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
          ),
          barGroups: _dayWiseData.asMap().entries.map((e) {
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: e.value['value'],
                  width: 12,
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.teal,
                )
              ],
            );
          }).toList(),
        ),
      ),
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
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...shownData.map((e) => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e['day'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('${e['value'].toStringAsFixed(1)} g', style: const TextStyle(color: Colors.black54)),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(e['product'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ),
              const Divider(height: 16),
            ],
          )),
          Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  _showAll = !_showAll;
                });
              },
              child: Text(_showAll ? 'View Less' : 'View All'),
            ),
          )
        ],
      ),
    );
  }
}
