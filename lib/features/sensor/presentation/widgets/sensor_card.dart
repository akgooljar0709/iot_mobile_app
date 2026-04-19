import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class SensorCard extends StatelessWidget {
  final String title;
  final String value;
  final bool isCritical;

  const SensorCard({
    super.key,
    required this.title,
    required this.value,
    required this.isCritical,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isCritical ? AppColors.criticalBackground : AppColors.normalBackground,
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}