import 'package:flutter/material.dart';
import 'sensor_local_db.dart';
import 'settings_model.dart';

class SettingsRepository {
  final SensorLocalDB _dbHelper;

  SettingsRepository({SensorLocalDB? dbHelper}) : _dbHelper = dbHelper ?? SensorLocalDB();

  Future<SettingsModel> loadSettings() async {
    final thresholdString = await _dbHelper.getSetting('threshold');
    final themeModeString = await _dbHelper.getSetting('themeMode');

    final threshold = thresholdString != null
        ? double.tryParse(thresholdString) ?? SettingsModel.defaultThreshold
        : SettingsModel.defaultThreshold;

    final themeMode = _parseThemeMode(themeModeString);

    return SettingsModel(threshold: threshold, themeMode: themeMode);
  }

  Future<void> saveThreshold(double threshold) async {
    await _dbHelper.saveSetting('threshold', threshold.toString());
  }

  Future<void> saveThemeMode(ThemeMode themeMode) async {
    await _dbHelper.saveSetting('themeMode', _themeModeToString(themeMode));
  }

  ThemeMode _parseThemeMode(String? value) {
    if (value == 'light') {
      return ThemeMode.light;
    }
    if (value == 'dark') {
      return ThemeMode.dark;
    }
    return SettingsModel.defaultThemeMode;
  }

  String _themeModeToString(ThemeMode themeMode) {
    if (themeMode == ThemeMode.light) {
      return 'light';
    }
    if (themeMode == ThemeMode.dark) {
      return 'dark';
    }
    return 'system';
  }
}
