import '../../data/models/weather_data.dart';

/// Domain layer interface for weather operations
/// 
/// This interface defines the business logic contract for weather operations.
/// The actual implementation may use caching, retries, and other strategies.
abstract class WeatherRepository {
  /// Gets current weather for a given city
  /// 
  /// Parameters:
  /// - [city]: City name or ID
  /// 
  /// Throws:
  /// - [WeatherApiException] on API errors
  /// - [WeatherNetworkException] on network issues
  Future<WeatherData> getWeather(String city);

  /// Clears any cached weather data
  void clearCache();

  /// Gets cache size for monitoring purposes
  int get cacheSize;
}
