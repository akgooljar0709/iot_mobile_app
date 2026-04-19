import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../../../core/constants/app_constants.dart';
import '../exceptions/weather_exceptions.dart';
import '../models/weather_data.dart';

/// Remote data source for weather data from OpenWeatherMap API
/// 
/// This class handles all HTTP communication with the OpenWeatherMap API.
/// It does not contain business logic or caching - just API calls.
abstract class WeatherRemoteDataSource {
  Future<WeatherData> getWeatherByCity(String city);
}

/// Implementation of WeatherRemoteDataSource
class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final http.Client httpClient;

  WeatherRemoteDataSourceImpl({required this.httpClient});

  /// Fetches current weather for a given city or city ID
  /// 
  /// Supports both city names (e.g., "London") and city IDs (numeric strings)
  /// 
  /// Throws:
  /// - [WeatherApiException] on API errors
  /// - [WeatherNetworkException] on network issues
  @override
  Future<WeatherData> getWeatherByCity(String city) async {
    _validateApiKey();

    final queryParam = _buildQueryParameter(city);
    final url = Uri.parse('${ApiConfig.openWeatherMapBaseUrl}?$queryParam'
        '&appid=${ApiConfig.openWeatherMapApiKey}&units=metric');

    try {
      final response = await httpClient
          .get(url)
          .timeout(AppConstants.apiTimeout);

      return _handleResponse(response, city);
    } on TimeoutException {
      throw WeatherNetworkException('Request timeout. Please check your connection.');
    } on SocketException {
      throw WeatherNetworkException('Network error. Please check your internet connection.');
    } on IOException catch (e) {
      throw WeatherNetworkException('Network error: $e');
    }
  }

  /// Validates that the API key is configured
  void _validateApiKey() {
    if (ApiConfig.openWeatherMapApiKey ==
        'YOUR_OPENWEATHERMAP_API_KEY') {
      throw WeatherApiException(
        'API key not configured. Please set your OpenWeatherMap API key.',
      );
    }
  }

  /// Builds the appropriate query parameter for city name or ID
  String _buildQueryParameter(String location) {
    final isNumeric = int.tryParse(location) != null;
    return isNumeric ? 'id=$location' : 'q=$location';
  }

  /// Handles HTTP response and converts to WeatherData
  WeatherData _handleResponse(http.Response response, String location) {
    switch (response.statusCode) {
      case 200:
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return WeatherData.fromJson(jsonData);

      case 401:
        throw WeatherApiException(
          'Invalid API key. Please check your OpenWeatherMap configuration.',
          statusCode: 401,
        );

      case 404:
        throw WeatherApiException(
          'Location not found: $location. Please try a different location.',
          statusCode: 404,
        );

      case 429:
        throw WeatherApiException(
          'API rate limit exceeded. Please try again later.',
          statusCode: 429,
        );

      default:
        throw WeatherApiException(
          'Failed to fetch weather data (Status: ${response.statusCode})',
          statusCode: response.statusCode,
        );
    }
  }
}
