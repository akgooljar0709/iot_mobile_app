import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../core/config/api_config.dart';

// Custom exceptions for better error handling
class WeatherApiException implements Exception {
  final String message;
  final int? statusCode;

  WeatherApiException(this.message, {this.statusCode});

  @override
  String toString() => 'WeatherApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class WeatherNetworkException implements Exception {
  final String message;

  WeatherNetworkException(this.message);

  @override
  String toString() => 'WeatherNetworkException: $message';
}

class WeatherData {
  final double temperature;
  final double humidity;
  final String city;
  final DateTime timestamp;
  final String country;
  final String weatherDescription;
  final double windSpeed;

  WeatherData({
    required this.temperature,
    required this.humidity,
    required this.city,
    required this.timestamp,
    required this.country,
    required this.weatherDescription,
    required this.windSpeed,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: (json['main']['temp'] as num).toDouble(),
      humidity: (json['main']['humidity'] as num).toDouble(),
      city: json['name'] as String,
      country: json['sys']['country'] as String,
      weatherDescription: json['weather'][0]['description'] as String,
      windSpeed: (json['wind']['speed'] as num?)?.toDouble() ?? 0.0,
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'humidity': humidity,
      'city': city,
      'country': country,
      'weatherDescription': weatherDescription,
      'windSpeed': windSpeed,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class WeatherService {
  static const String _apiKey = ApiConfig.openWeatherMapApiKey;
  static const String _baseUrl = ApiConfig.openWeatherMapBaseUrl;
  static const Duration _timeout = Duration(seconds: 10);
  static const int _maxRetries = 3;

  final http.Client _client;

  // Simple in-memory cache
  final Map<String, _CacheEntry> _cache = {};

  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  // Cache entry with expiration
  static const Duration _cacheDuration = Duration(minutes: 5);

  Future<WeatherData> fetchCurrentWeather({
    String? city,
    bool useCache = true,
  }) async {
    final cityName = city ?? 'Pamplemousses';
    final cacheKey = cityName.toLowerCase();

    // Check cache first
    if (useCache && _isCacheValid(cacheKey)) {
      return _cache[cacheKey]!.data;
    }

    Exception? lastException;

    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      try {
        final weatherData = await _fetchWeatherData(cityName);

        // Cache the result
        _cache[cacheKey] = _CacheEntry(
          data: weatherData,
          timestamp: DateTime.now(),
        );

        return weatherData;
      } catch (e) {
        lastException = e as Exception;
        if (attempt < _maxRetries - 1) {
          // Wait before retrying (exponential backoff)
          await Future.delayed(Duration(seconds: attempt + 1));
        }
      }
    }

    throw lastException ?? WeatherApiException('Failed to fetch weather data after $_maxRetries attempts');
  }

  Future<WeatherData> _fetchWeatherData(String location) async {
    if (_apiKey == 'YOUR_OPENWEATHERMAP_API_KEY') {
      throw WeatherApiException('API key not configured. Please set your OpenWeatherMap API key in api_config.dart');
    }

    // Check if location is a city ID (numeric) or city name (alphabetic)
    final isCityId = int.tryParse(location) != null;
    final queryParam = isCityId ? 'id=$location' : 'q=$location';

    final url = Uri.parse('$_baseUrl?$queryParam&appid=$_apiKey&units=metric');

    try {
      final response = await _client.get(url).timeout(_timeout);

      switch (response.statusCode) {
        case 200:
          final jsonData = json.decode(response.body) as Map<String, dynamic>;
          return WeatherData.fromJson(jsonData);

        case 401:
          throw WeatherApiException('Invalid API key', statusCode: response.statusCode);

        case 404:
          throw WeatherApiException('Location not found: $location', statusCode: response.statusCode);

        case 429:
          throw WeatherApiException('API rate limit exceeded', statusCode: response.statusCode);

        default:
          throw WeatherApiException(
            'Failed to load weather data',
            statusCode: response.statusCode,
          );
      }
    } on SocketException catch (e) {
      throw WeatherNetworkException('Network error: ${e.message}');
    } on FormatException catch (e) {
      throw WeatherApiException('Invalid response format: ${e.message}');
    } on TimeoutException catch (e) {
      throw WeatherNetworkException('Request timeout: ${e.message}');
    } catch (e) {
      throw WeatherApiException('Unexpected error: $e');
    }
  }

  bool _isCacheValid(String key) {
    final entry = _cache[key];
    if (entry == null) return false;

    final age = DateTime.now().difference(entry.timestamp);
    return age < _cacheDuration;
  }

  // Clear cache (useful for testing or manual refresh)
  void clearCache() {
    _cache.clear();
  }

  // Get cache size for debugging
  int get cacheSize => _cache.length;

  void dispose() {
    _client.close();
  }
}

// Cache entry helper class
class _CacheEntry {
  final WeatherData data;
  final DateTime timestamp;

  _CacheEntry({required this.data, required this.timestamp});
}