import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';
import '../../data/datasources/weather_remote_datasource.dart';
import '../../data/exceptions/weather_exceptions.dart';
import '../../data/models/weather_data.dart';
import './weather_repository.dart';

/// Cache entry holding weather data and its timestamp
class _CacheEntry {
  final WeatherData data;
  final DateTime timestamp;

  _CacheEntry({required this.data, required this.timestamp});

  /// Checks if cache entry is still valid
  bool isValid(Duration duration) {
    final age = DateTime.now().difference(timestamp);
    return age < duration;
  }
}

/// Implementation of WeatherRepository with caching and retry logic
/// 
/// This repository wraps the remote data source with:
/// - In-memory caching to reduce API calls
/// - Automatic retry with exponential backoff
/// - Proper error handling and translation
class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource _remoteDataSource;

  /// In-memory cache for weather data
  final Map<String, _CacheEntry> _cache = {};

  WeatherRepositoryImpl({
    WeatherRemoteDataSource? remoteDataSource,
    http.Client? httpClient,
  }) : _remoteDataSource = remoteDataSource ??
            WeatherRemoteDataSourceImpl(
              httpClient: httpClient ?? http.Client(),
            );

  @override
  Future<WeatherData> getWeather(String city) async {
    final cacheKey = city.toLowerCase();

    // Check cache first
    if (_isCacheValid(cacheKey)) {
      return _cache[cacheKey]!.data;
    }

    Exception? lastException;

    // Retry logic with exponential backoff
    for (int attempt = 0; attempt < AppConstants.maxRetries; attempt++) {
      try {
        final weatherData = await _remoteDataSource.getWeatherByCity(city);

        // Cache the result
        _cache[cacheKey] = _CacheEntry(
          data: weatherData,
          timestamp: DateTime.now(),
        );

        return weatherData;
      } catch (e) {
        lastException = e as Exception;

        // Don't retry on API errors (401, 404, etc.)
        if (e is WeatherApiException) {
          rethrow;
        }

        // Retry on network errors with exponential backoff
        if (e is WeatherNetworkException && attempt < AppConstants.maxRetries - 1) {
          await Future.delayed(Duration(seconds: attempt + 1));
        }
      }
    }

    throw lastException ??
        WeatherException('Failed to fetch weather after ${AppConstants.maxRetries} attempts');
  }

  /// Checks if cached weather data is still valid
  bool _isCacheValid(String cacheKey) {
    final entry = _cache[cacheKey];
    return entry != null && entry.isValid(AppConstants.weatherCacheDuration);
  }

  @override
  void clearCache() {
    _cache.clear();
  }

  @override
  int get cacheSize => _cache.length;
}
