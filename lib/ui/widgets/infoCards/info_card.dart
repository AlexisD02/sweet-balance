import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final double height;

  const InfoCard({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
