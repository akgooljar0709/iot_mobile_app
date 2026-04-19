import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class StatusText extends StatelessWidget {
  final String status;
  final bool isCritical;

  const StatusText({
    super.key,
    required this.status,
    required this.isCritical,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      status,
      style: TextStyle(
        fontSize: 18,
        color: isCritical ? AppColors.critical : AppColors.normal,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}