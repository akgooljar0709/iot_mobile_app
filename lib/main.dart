import 'package:flutter/material.dart';
import 'package:iot_mobile_app/core/constants/colors.dart';
import 'package:iot_mobile_app/features/sensor/data/settings_repository.dart';
import 'package:iot_mobile_app/features/sensor/data/settings_model.dart';
import 'package:iot_mobile_app/features/sensor/presentation/pages/dashboard/enhanced_dashboard_page.dart';
import 'package:iot_mobile_app/l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final SettingsRepository _settingsRepository;
  ThemeMode _themeMode = ThemeMode.system;
  double _threshold = SettingsModel.defaultThreshold;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _settingsRepository = SettingsRepository();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await _settingsRepository.loadSettings();
      setState(() {
        _themeMode = settings.themeMode;
        _threshold = settings.threshold;
        _isLoaded = true;
      });
    } catch (e) {
      debugPrint('Failed to load settings: $e');
      setState(() {
        _themeMode = SettingsModel.defaultThemeMode;
        _threshold = SettingsModel.defaultThreshold;
        _isLoaded = true;
      });
    }
  }

  Future<void> _updateSettings(SettingsModel settings) async {
    await _settingsRepository.saveThreshold(settings.threshold);
    await _settingsRepository.saveThemeMode(settings.themeMode);
    setState(() {
      _threshold = settings.threshold;
      _themeMode = settings.themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IoT Weather Monitor',
      theme: ThemeData(
        primarySwatch: AppColors.primary,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary.shade500, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: EnhancedDashboardPage(
        settingsRepository: _settingsRepository,
        initialSettings: SettingsModel(threshold: _threshold, themeMode: _themeMode),
        onSettingsChanged: _updateSettings,
      ),
    );
  }
}
