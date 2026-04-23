import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:iot_mobile_app/l10n/app_localizations.dart';
import 'package:iot_mobile_app/features/sensor/data/sensor_model.dart';
import 'package:iot_mobile_app/features/sensor/data/sensor_repository_impl.dart';
import 'package:iot_mobile_app/features/sensor/data/settings_model.dart';
import 'package:iot_mobile_app/features/sensor/data/settings_repository.dart';
import 'package:iot_mobile_app/features/sensor/data/weather_repository.dart';
import 'package:iot_mobile_app/features/sensor/data/weather_service.dart';
import 'package:iot_mobile_app/features/sensor/data/ai_service.dart';
import 'package:iot_mobile_app/features/sensor/presentation/pages/city_selection_page.dart';
import 'package:iot_mobile_app/features/sensor/presentation/pages/sensor_history_page.dart';
import 'package:iot_mobile_app/features/sensor/presentation/pages/settings_page.dart';
import 'package:iot_mobile_app/features/sensor/presentation/pages/realtime_arduino_page.dart';
import 'package:iot_mobile_app/features/sensor/presentation/widgets/enhanced_weather_card.dart';
import 'package:iot_mobile_app/features/sensor/presentation/widgets/weather_chart_widget.dart';
import 'package:iot_mobile_app/features/auth/data/auth_service.dart';

class EnhancedDashboardPage extends StatefulWidget {
  final SettingsRepository settingsRepository;
  final SettingsModel initialSettings;
  final ValueChanged<SettingsModel> onSettingsChanged;

  const EnhancedDashboardPage({
    super.key,
    required this.settingsRepository,
    required this.initialSettings,
    required this.onSettingsChanged,
  });

  @override
  State<EnhancedDashboardPage> createState() => _EnhancedDashboardPageState();
}

class _EnhancedDashboardPageState extends State<EnhancedDashboardPage> {
  final repo = SensorRepositoryImpl();
  late final WeatherRepository weatherRepository;
  late final WeatherService weatherService;
  late final AIService aiService;
  late final AuthService _authService;

  double temperature = 25;
  double humidity = 50;
  double windSpeed = 0;
  String _currentCity = 'Pamplemousses';
  String city = 'Loading...';
  String weatherDescription = '';
  bool isLoading = true;
  String? errorMessage;
  bool isNetworkError = false;

  late SettingsModel _settings;
  late List<SensorModel> sensorHistory = [];

  // AIoT variables
  double predictedTemperature = 25.0;
  bool isAnomaly = false;
  String trend = 'Stable';
  double recommendedThreshold = 30.0;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _settings = widget.initialSettings;
    weatherService = WeatherService();
    weatherRepository = WeatherRepositoryImpl(weatherService);
    aiService = AIService(repo);
    _authService = AuthService();
    _loadWeatherData();
    _loadSensorHistory();
  }

  void _loadWeatherData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
        isNetworkError = false;
      });

      final weatherData = await weatherRepository.getCurrentWeather(city: _currentCity);
      setState(() {
        temperature = weatherData.temperature;
        humidity = weatherData.humidity;
        windSpeed = weatherData.windSpeed;
        city = weatherData.city;
        weatherDescription = weatherData.weatherDescription;
        isLoading = false;
      });

      // Save to database
      await repo.insertData(
        SensorModel(
          temperature: temperature,
          humidity: humidity,
          timestamp: DateTime.now().toString(),
        ),
      );

      // Refresh sensor history
      _loadSensorHistory();

      // Load AI predictions
      _loadAIPredictions();
    } on WeatherApiException catch (e) {
      setState(() {
        errorMessage = _getErrorMessage(e);
        isLoading = false;
        isNetworkError = false;
      });
    } on WeatherNetworkException catch (e) {
      setState(() {
        errorMessage = 'Network error: ${e.message}';
        isLoading = false;
        isNetworkError = true;
      });
      _simulateLocalReading();
      _retryWithDelay();
    } catch (e) {
      setState(() {
        errorMessage = 'Unexpected error occurred: $e';
        isLoading = false;
        isNetworkError = false;
      });
    }
  }

  void _loadSensorHistory() async {
    try {
      final data = await repo.getAllData();
      setState(() {
        // Get last 20 records for the chart
        sensorHistory = data.length > 20 ? data.sublist(data.length - 20) : data;
      });
    } catch (e) {
      debugPrint('Error loading sensor history: $e');
    }
  }

  void _loadAIPredictions() async {
    try {
      final predTemp = await aiService.predictNextTemperature();
      final anomaly = await aiService.detectAnomaly();
      final trendData = await aiService.getTrend();
      final recThreshold = await aiService.recommendThreshold();

      setState(() {
        predictedTemperature = predTemp;
        isAnomaly = anomaly;
        trend = trendData;
        recommendedThreshold = recThreshold;
      });
    } catch (e) {
      debugPrint('Error loading AI predictions: $e');
    }
  }

  String _getErrorMessage(WeatherApiException e) {
    if (e.statusCode == 401) {
      return 'API key is invalid. Please check your OpenWeatherMap API key configuration.';
    } else if (e.statusCode == 404) {
      return 'City not found. Please try a different city.';
    } else if (e.statusCode == 429) {
      return 'API rate limit exceeded. Please try again later.';
    } else {
      return 'Failed to load weather data: ${e.message}';
    }
  }

  void _retryWithDelay() {
    if (isNetworkError) {
      Future.delayed(const Duration(seconds: 2), _loadWeatherData);
    }
  }

  Future<void> _simulateLocalReading() async {
    final random = Random();
    final simulatedTemperature = (temperature + random.nextDouble() * 4 - 2).clamp(18.0, 45.0);
    final simulatedHumidity = (humidity + random.nextDouble() * 8 - 4).clamp(10.0, 100.0);

    setState(() {
      temperature = simulatedTemperature;
      humidity = simulatedHumidity;
      windSpeed = (windSpeed + random.nextDouble() * 1.5 - 0.75).clamp(0.0, 12.0);
      city = _currentCity;
      weatherDescription = 'Simulated sensor reading';
      isLoading = false;
    });

    await repo.insertData(
      SensorModel(
        temperature: temperature,
        humidity: humidity,
        timestamp: DateTime.now().toString(),
      ),
    );

    _loadSensorHistory();
  }

  void startSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      _loadWeatherData();
    });
  }

  void _selectCity() async {
    final selectedCity = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => CitySelectionPage(currentCity: _currentCity),
      ),
    );

    if (selectedCity != null) {
      setState(() {
        _currentCity = selectedCity;
        city = selectedCity;
      });
      weatherRepository.clearCache();
      _loadWeatherData();
    }
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    weatherService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isCritical = temperature > _settings.threshold;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.iotDashboard ?? 'IoT Dashboard'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () async {
              final updatedSettings = await Navigator.of(context).push<SettingsModel>(
                MaterialPageRoute(
                  builder: (_) => SettingsPage(settings: _settings),
                ),
              );
              if (updatedSettings != null) {
                widget.onSettingsChanged(updatedSettings);
                setState(() {
                  _settings = updatedSettings;
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.location_on),
            tooltip: 'Select City',
            onPressed: _selectCity,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: AppLocalizations.of(context)?.refresh ?? 'Refresh',
            onPressed: () {
              weatherRepository.clearCache();
              _loadWeatherData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: AppLocalizations.of(context)?.viewHistory ?? 'View History',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SensorHistoryPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.cable),
            tooltip: 'Arduino Real-Time Data',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const RealtimeArduinoPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          weatherRepository.clearCache();
          _loadWeatherData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Error Message
              if (errorMessage != null)
                Card(
                  color: isNetworkError ? Colors.orange.shade50 : Colors.red.shade50,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          isNetworkError ? Icons.wifi_off : Icons.error,
                          color: isNetworkError ? Colors.orange : Colors.red,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                errorMessage!,
                                style: TextStyle(
                                  color: isNetworkError
                                      ? Colors.orange.shade800
                                      : Colors.red.shade800,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (isNetworkError)
                                Text(
                                  'Retrying automatically...',
                                  style: TextStyle(
                                    color: Colors.orange.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Weather Card
              EnhancedWeatherCard(
                city: city,
                temperature: temperature,
                humidity: humidity,
                windSpeed: windSpeed,
                weatherDescription: weatherDescription,
                isLoading: isLoading,
                errorMessage: errorMessage,
              ),

              const SizedBox(height: 24),

              // Status Indicator
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isCritical
                      ? Colors.red.shade50
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCritical
                        ? Colors.red.shade200
                        : Colors.green.shade200,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isCritical
                          ? Icons.warning
                          : Icons.check_circle,
                      color: isCritical
                          ? Colors.red.shade700
                          : Colors.green.shade700,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isCritical ? 'Système de refroidissement activé' : 'Normal',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isCritical
                                ? Colors.red.shade700
                                : Colors.green.shade700,
                          ),
                        ),
                        Text(
                          isCritical
                              ? 'Temperature exceeds ${_settings.threshold.toStringAsFixed(1)}°C'
                              : 'All conditions normal',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // AIoT Predictions Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.smart_toy,
                            color: Theme.of(context).primaryColor,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'AIoT Analysis',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _AIPredictionItem(
                              label: 'Predicted Temp',
                              value: '${predictedTemperature.toStringAsFixed(1)}°C',
                              icon: Icons.trending_up,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _AIPredictionItem(
                              label: 'Trend',
                              value: trend,
                              icon: trend == 'Hausse' ? Icons.arrow_upward :
                                    trend == 'Baisse' ? Icons.arrow_downward : Icons.horizontal_rule,
                              color: trend == 'Hausse' ? Colors.red :
                                     trend == 'Baisse' ? Colors.green : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _AIPredictionItem(
                              label: 'Anomaly',
                              value: isAnomaly ? 'Detected' : 'None',
                              icon: isAnomaly ? Icons.warning : Icons.check,
                              color: isAnomaly ? Colors.orange : Colors.green,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _AIPredictionItem(
                              label: 'Recommended Threshold',
                              value: '${recommendedThreshold.toStringAsFixed(1)}°C',
                              icon: Icons.settings_suggest,
                              color: Colors.purple,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Chart Section
              if (sensorHistory.isNotEmpty)
                WeatherChartWidget(
                  sensorData: sensorHistory,
                  title: 'Temperature Trend',
                  yAxisLabel: 'Temperature (°C)',
                  lineColor: const Color(0xFF42A5F5),
                ),

              const SizedBox(height: 24),

              // Quick Stats
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _QuickStatCard(
                    title: 'Avg Temperature',
                    value: _calculateAverage(
                      sensorHistory.map((e) => e.temperature).toList(),
                    ),
                    unit: '°C',
                    icon: Icons.thermostat,
                    color: const Color(0xFF42A5F5),
                  ),
                  _QuickStatCard(
                    title: 'Data Points',
                    value: sensorHistory.length.toString(),
                    unit: '',
                    icon: Icons.show_chart,
                    color: const Color(0xFF66BB6A),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateAverage(List<double> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }
}

class _QuickStatCard extends StatelessWidget {
  final String title;
  final dynamic value;
  final String unit;
  final IconData icon;
  final Color color;

  const _QuickStatCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value is double
                        ? value.toStringAsFixed(1)
                        : value.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  TextSpan(
                    text: unit,
                    style: TextStyle(
                      fontSize: 12,
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AIPredictionItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _AIPredictionItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
