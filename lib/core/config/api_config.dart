// API Configuration
// Get your free API key from: https://openweathermap.org/api
// Set your API key using environment variables or replace the default value

import 'environment_config.dart';

class ApiConfig {
  static const String openWeatherMapApiKey = EnvironmentConfig.openWeatherMapApiKey;
  static const String openWeatherMapBaseUrl = 'https://api.openweathermap.org/data/2.5/weather';
}