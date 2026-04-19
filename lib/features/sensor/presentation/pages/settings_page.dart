import 'package:flutter/material.dart';
import 'package:iot_mobile_app/features/sensor/data/settings_model.dart';

class SettingsPage extends StatefulWidget {
  final SettingsModel settings;

  const SettingsPage({super.key, required this.settings});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late double _threshold;
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _threshold = widget.settings.threshold;
    _themeMode = widget.settings.themeMode;
  }

  void _saveAndClose() {
    final result = SettingsModel(
      threshold: _threshold,
      themeMode: _themeMode,
    );
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveAndClose,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alert Threshold',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Current threshold: ${_threshold.toStringAsFixed(1)} °C'),
            Slider(
              min: 20,
              max: 40,
              divisions: 20,
              value: _threshold,
              label: '${_threshold.toStringAsFixed(1)} °C',
              onChanged: (value) {
                setState(() {
                  _threshold = value;
                });
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Theme',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            RadioListTile<ThemeMode>(
              title: const Text('System'),
              value: ThemeMode.system,
              groupValue: _themeMode,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _themeMode = value;
                  });
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: _themeMode,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _themeMode = value;
                  });
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: _themeMode,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _themeMode = value;
                  });
                }
              },
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: _saveAndClose,
                child: const Text('Save settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
