import 'package:flutter/material.dart';

class SettingsModel {
  final double threshold;
  final ThemeMode themeMode;

  const SettingsModel({
    required this.threshold,
    required this.themeMode,
  });

  static const defaultThreshold = 30.0;
  static const defaultThemeMode = ThemeMode.system;

  SettingsModel copyWith({
    double? threshold,
    ThemeMode? themeMode,
  }) {
    return SettingsModel(
      threshold: threshold ?? this.threshold,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
