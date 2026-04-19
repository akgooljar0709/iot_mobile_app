import 'package:flutter/material.dart';

class WeatherIconWidget extends StatelessWidget {
  final String weatherDescription;
  final double size;

  const WeatherIconWidget({
    super.key,
    required this.weatherDescription,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    final description = weatherDescription.toLowerCase();
    IconData iconData;
    Color color;

    if (description.contains('clear') || description.contains('sunny')) {
      iconData = Icons.wb_sunny;
      color = const Color(0xFFFFB800);
    } else if (description.contains('cloud')) {
      iconData = Icons.wb_cloudy;
      color = const Color(0xFF90CAF9);
    } else if (description.contains('rain') || description.contains('drizzle')) {
      iconData = Icons.grain;
      color = const Color(0xFF42A5F5);
    } else if (description.contains('thunder') || description.contains('storm')) {
      iconData = Icons.flash_on;
      color = const Color(0xFFFFA726);
    } else if (description.contains('snow')) {
      iconData = Icons.ac_unit;
      color = const Color(0xFF90CAF9);
    } else if (description.contains('wind')) {
      iconData = Icons.air;
      color = const Color(0xFF78909C);
    } else if (description.contains('fog') || description.contains('mist')) {
      iconData = Icons.cloud;
      color = const Color(0xFFB0BEC5);
    } else {
      iconData = Icons.cloud_queue;
      color = const Color(0xFF90CAF9);
    }

    return Icon(
      iconData,
      size: size,
      color: color,
    );
  }

  static Widget getWeatherIcon(String description, {double size = 50}) {
    return WeatherIconWidget(weatherDescription: description, size: size);
  }
}
