import 'package:flutter/material.dart';
import 'package:iot_mobile_app/l10n/app_localizations.dart';
import 'package:iot_mobile_app/features/sensor/data/settings_repository.dart';
import '../../data/sensor_model.dart';
import '../../data/sensor_repository_impl.dart';
import '../../../../core/constants/colors.dart';

class SensorHistoryPage extends StatefulWidget {
  const SensorHistoryPage({super.key});

  @override
  State<SensorHistoryPage> createState() => _SensorHistoryPageState();
}

class _SensorHistoryPageState extends State<SensorHistoryPage> {
  final repo = SensorRepositoryImpl();
  final _settingsRepository = SettingsRepository();
  late Future<List<SensorModel>> _historyFuture;
  double _threshold = 30.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadHistory();
  }

  Future<void> _loadSettings() async {
    final settings = await _settingsRepository.loadSettings();
    setState(() {
      _threshold = settings.threshold;
    });
  }

  void _loadHistory() {
    _historyFuture = repo.getAllData();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.sensorHistory),
      ),
      body: FutureBuilder<List<SensorModel>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final readings = snapshot.data ?? [];
          if (readings.isEmpty) {
            return Center(child: Text(l10n.noHistory));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: readings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final reading = readings[index];
              final isCritical = reading.temperature > _threshold;
              return Card(
                color: isCritical ? AppColors.criticalBackground : AppColors.normalBackground,
                child: ListTile(
                  leading: Icon(
                    Icons.thermostat,
                    color: isCritical ? AppColors.critical : AppColors.normal,
                  ),
                  title: Text(
                    '${l10n.temperature}: ${reading.temperature.toStringAsFixed(1)} °C',
                  ),
                  subtitle: Text(
                    '${l10n.humidity}: ${reading.humidity.toStringAsFixed(1)} %\n${reading.timestamp}',
                  ),
                  isThreeLine: true,
                  trailing: isCritical
                      ? Icon(
                          Icons.warning,
                          color: AppColors.critical,
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(_loadHistory);
        },
        tooltip: l10n.refresh,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
