import 'package:flutter/material.dart';
import 'package:iot_mobile_app/core/constants/app_constants.dart';
import 'package:iot_mobile_app/l10n/app_localizations.dart';
import 'package:iot_mobile_app/features/sensor/presentation/pages/city_selection_page.dart';
import 'package:iot_mobile_app/features/sensor/presentation/pages/sensor_history_page.dart';
import 'package:iot_mobile_app/features/sensor/presentation/widgets/enhanced_weather_card.dart';
import 'package:iot_mobile_app/features/sensor/domain/repositories/weather_repository.dart';
import 'package:iot_mobile_app/features/sensor/data/models/weather_data.dart';
import 'package:iot_mobile_app/features/sensor/presentation/providers/service_locator.dart';

class ModernDashboardPage extends StatefulWidget {
  const ModernDashboardPage({super.key});

  @override
  State<ModernDashboardPage> createState() =>
      _ModernDashboardPageState();
}

class _ModernDashboardPageState extends State<ModernDashboardPage> {
  late String _currentCity;
  late WeatherRepository _weatherRepository;
  WeatherData? _weatherData;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _currentCity = 'Pamplemousses';
    _weatherRepository = ServiceLocator.getWeatherRepository();
    
    // Load initial weather data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWeather(_currentCity);
      
      // Set up auto-refresh
      _startAutoRefresh();
    });
  }

  Future<void> _loadWeather(String city) async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final weather = await _weatherRepository.getWeather(city);
      if (mounted) {
        setState(() {
          _weatherData = weather;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = _mapErrorToMessage(e);
          _isLoading = false;
        });
      }
    }
  }

  void _startAutoRefresh() {
    Future.delayed(AppConstants.autoRefreshInterval, () {
      if (mounted) {
        _loadWeather(_currentCity);
        _startAutoRefresh();
      }
    });
  }

  void _selectCity() async {
    final selectedCity = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => CitySelectionPage(currentCity: _currentCity),
      ),
    );

    if (selectedCity != null && selectedCity != _currentCity) {
      setState(() {
        _currentCity = selectedCity;
      });
      
      _loadWeather(selectedCity);
    }
  }

  String _mapErrorToMessage(dynamic error) {
    return 'Failed to load weather data. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    final isCritical = _weatherData != null &&
        _weatherData!.temperature > AppConstants.temperatureThreshold;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.iotDashboard ?? 'IoT Dashboard'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on),
            tooltip: 'Select City',
            onPressed: _selectCity,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: AppLocalizations.of(context)?.refresh ?? 'Refresh',
            onPressed: () {
              _weatherRepository.clearCache();
              _loadWeather(_currentCity);
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
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _weatherRepository.clearCache();
          await _loadWeather(_currentCity);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Error Message
              if (_errorMessage != null)
                Card(
                  color: Colors.red.shade50,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.error, color: Colors.red.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorMessage ?? '',
                            style: TextStyle(
                              color: Colors.red.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Weather Card
              EnhancedWeatherCard(
                city: _weatherData?.city ?? _currentCity,
                temperature: _weatherData?.temperature ?? 0,
                humidity: _weatherData?.humidity ?? 0,
                windSpeed: _weatherData?.windSpeed ?? 0,
                weatherDescription:
                    _weatherData?.weatherDescription ?? '',
                isLoading: _isLoading,
                errorMessage: _errorMessage,
              ),

              const SizedBox(height: 24),

              // Status Indicator
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isCritical ? Colors.red.shade50 : Colors.green.shade50,
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
                      isCritical ? Icons.warning : Icons.check_circle,
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
                          isCritical ? 'High Temperature' : 'Normal',
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
                              ? 'Temperature exceeds ${AppConstants.temperatureThreshold}°C'
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

              // Chart Section - TODO: implement with sensor data
              // if (recentData.isNotEmpty)
              //   WeatherChartWidget(
              //     sensorData: recentData,
              //     title: 'Temperature Trend',
              //     yAxisLabel: 'Temperature (°C)',
              //     lineColor: const Color(0xFF42A5F5),
              //   ),

              const SizedBox(height: 24),

              // Quick Stats - TODO: implement with sensor data
              // if (recentData.isNotEmpty)
              //   GridView.count(
              //     crossAxisCount: 2,
              //     shrinkWrap: true,
              //     physics: const NeverScrollableScrollPhysics(),
              //     mainAxisSpacing: 16,
              //     crossAxisSpacing: 16,
              //     children: [
              //       _QuickStatCard(
              //         title: 'Avg Temperature',
              //         value: _calculateAverage(
              //           recentData.map((e) => e.temperature).toList(),
              //         ),
              //         unit: '°C',
              //         icon: Icons.thermostat,
              //         color: const Color(0xFF42A5F5),
              //       ),
              //       _QuickStatCard(
              //         title: 'Data Points',
              //         value: recentData.length.toString(),
              //         unit: '',
              //         icon: Icons.show_chart,
              //         color: const Color(0xFF66BB6A),
              //       ),
              //     ],
              //   ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
