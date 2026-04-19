import 'package:flutter/material.dart';
import 'package:iot_mobile_app/features/sensor/presentation/widgets/weather_icon_widget.dart';

class EnhancedWeatherCard extends StatelessWidget {
  final String city;
  final double temperature;
  final double humidity;
  final double windSpeed;
  final String weatherDescription;
  final bool isLoading;
  final String? errorMessage;

  const EnhancedWeatherCard({
    super.key,
    required this.city,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.weatherDescription,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFEF5350), Color(0xFFC62828)],
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 48),
              const SizedBox(height: 16),
              Text(
                errorMessage ?? 'Error loading weather',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _getGradientColors(weatherDescription),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // City and Weather Description
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        city,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        weatherDescription,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                WeatherIconWidget(
                  weatherDescription: weatherDescription,
                  size: 80,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Temperature and Humidity
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _WeatherInfoWidget(
                  icon: Icons.thermostat,
                  label: 'Temperature',
                  value: '${temperature.toStringAsFixed(1)}°C',
                ),
                _WeatherInfoWidget(
                  icon: Icons.opacity,
                  label: 'Humidity',
                  value: '${humidity.toStringAsFixed(0)}%',
                ),
                _WeatherInfoWidget(
                  icon: Icons.air,
                  label: 'Wind Speed',
                  value: '${windSpeed.toStringAsFixed(1)} m/s',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _getGradientColors(String description) {
    final desc = description.toLowerCase();

    if (desc.contains('clear') || desc.contains('sunny')) {
      return const [Color(0xFFFFA726), Color(0xFFFF8A65)];
    } else if (desc.contains('cloud')) {
      return const [Color(0xFF90CAF9), Color(0xFF42A5F5)];
    } else if (desc.contains('rain') || desc.contains('drizzle')) {
      return const [Color(0xFF64B5F6), Color(0xFF1976D2)];
    } else if (desc.contains('thunder') || desc.contains('storm')) {
      return const [Color(0xFF5E35B1), Color(0xFF3E2723)];
    } else if (desc.contains('snow')) {
      return const [Color(0xFFE3F2FD), Color(0xFFBBDEFB)];
    } else {
      return const [Color(0xFF78909C), Color(0xFF455A64)];
    }
  }
}

class _WeatherInfoWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _WeatherInfoWidget({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
