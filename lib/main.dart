import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:iot_mobile_app/firebase_options.dart';
import 'package:iot_mobile_app/core/constants/colors.dart';
import 'package:iot_mobile_app/features/sensor/data/settings_repository.dart';
import 'package:iot_mobile_app/features/sensor/data/settings_model.dart';
import 'package:iot_mobile_app/features/sensor/presentation/pages/dashboard/enhanced_dashboard_page.dart';
import 'package:iot_mobile_app/features/auth/presentation/pages/login_page.dart';
import 'package:iot_mobile_app/features/auth/presentation/pages/signup_page.dart';
import 'package:iot_mobile_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:iot_mobile_app/features/auth/data/auth_service.dart';
import 'package:iot_mobile_app/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final SettingsRepository _settingsRepository;
  late final AuthService _authService;
  ThemeMode _themeMode = ThemeMode.system;
  double _threshold = SettingsModel.defaultThreshold;
  bool _isLoaded = false;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _settingsRepository = SettingsRepository();
    _authService = AuthService();
    _loadSettingsAndAuth();
  }

  Future<void> _loadSettingsAndAuth() async {
    try {
      final settings = await _settingsRepository.loadSettings();
      final isLoggedIn = await _authService.isLoggedIn();
      setState(() {
        _themeMode = settings.themeMode;
        _threshold = settings.threshold;
        _isLoggedIn = isLoggedIn;
        _isLoaded = true;
      });
    } catch (e) {
      debugPrint('Failed to load settings or auth: $e');
      setState(() {
        _themeMode = SettingsModel.defaultThemeMode;
        _threshold = SettingsModel.defaultThreshold;
        _isLoggedIn = false;
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
      home: _isLoggedIn
          ? EnhancedDashboardPage(
              settingsRepository: _settingsRepository,
              initialSettings: SettingsModel(threshold: _threshold, themeMode: _themeMode),
              onSettingsChanged: _updateSettings,
            )
          : const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/dashboard': (context) => EnhancedDashboardPage(
          settingsRepository: _settingsRepository,
          initialSettings: SettingsModel(threshold: _threshold, themeMode: _themeMode),
          onSettingsChanged: _updateSettings,
        ),
      },
    );
  }
}
