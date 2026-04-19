import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iot_mobile_app/l10n/app_localizations.dart';
import 'package:iot_mobile_app/features/sensor/data/sensor_model.dart';
import 'package:iot_mobile_app/features/sensor/data/sensor_repository_impl.dart';
import 'package:iot_mobile_app/features/sensor/data/weather_repository.dart';
import 'package:iot_mobile_app/features/sensor/data/weather_service.dart';
import 'package:iot_mobile_app/features/sensor/presentation/pages/sensor_history_page.dart';
import 'package:iot_mobile_app/features/sensor/presentation/widgets/sensor_card.dart';
import 'package:iot_mobile_app/features/sensor/presentation/widgets/status_text.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final repo = SensorRepositoryImpl();
  late final WeatherRepository weatherRepository;
  late final WeatherService weatherService;

  double temperature = 25;
  double humidity = 50;
  String city = 'Loading...';
  String weatherDescription = '';
  bool isLoading = true;
  String? errorMessage;
  bool isNetworkError = false;

  final double threshold = 30;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    weatherService = WeatherService();
    weatherRepository = WeatherRepositoryImpl(weatherService);
    _loadWeatherData();
    startSimulation();
  }

  void _loadWeatherData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
        isNetworkError = false;
      });

      final weatherData = await weatherRepository.getCurrentWeather();
      setState(() {
        temperature = weatherData.temperature;
        humidity = weatherData.humidity;
        city = '${weatherData.city}, ${weatherData.country}';
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
      _retryWithDelay();
    } catch (e) {
      setState(() {
        errorMessage = 'Unexpected error occurred';
        isLoading = false;
        isNetworkError = false;
      });
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

  void startSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      _loadWeatherData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    weatherService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isCritical = temperature > threshold;
    String statusText = isCritical ? AppLocalizations.of(context)!.coolingSystemActivated : AppLocalizations.of(context)!.normal;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.iotDashboard),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: AppLocalizations.of(context)!.refresh,
            onPressed: () {
              weatherRepository.clearCache();
              _loadWeatherData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: AppLocalizations.of(context)!.viewHistory,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SensorHistoryPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (errorMessage != null)
              Card(
                color: isNetworkError ? Colors.orange.shade50 : Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isNetworkError ? Icons.wifi_off : Icons.error,
                            color: isNetworkError ? Colors.orange : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              errorMessage!,
                              style: TextStyle(
                                color: isNetworkError ? Colors.orange.shade800 : Colors.red.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (isNetworkError) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Retrying automatically...',
                          style: TextStyle(
                            color: Colors.orange.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            if (isLoading)
              const CircularProgressIndicator()
            else ...[
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weather data for $city',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (weatherDescription.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          weatherDescription,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SensorCard(title: AppLocalizations.of(context)!.temperature, value: "$temperature °C", isCritical: isCritical),
              SensorCard(title: AppLocalizations.of(context)!.humidity, value: "$humidity %", isCritical: false),
              const SizedBox(height: 20),
              StatusText(status: statusText, isCritical: isCritical),
            ],
          ],
        ),
      ),
    );
  }
}