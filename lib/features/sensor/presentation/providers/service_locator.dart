import '../../data/datasources/weather_remote_datasource.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../domain/repositories/weather_repository_impl.dart';
import 'package:http/http.dart' as http;

/// Simple service locator for dependency injection
class ServiceLocator {
  static late WeatherRepository _weatherRepository;

  /// Initialize service locator - should be called in main()
  static void init() {
    _weatherRepository = WeatherRepositoryImpl(
      remoteDataSource: WeatherRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
    );
  }

  /// Get weather repository instance
  static WeatherRepository getWeatherRepository() {
    return _weatherRepository;
  }
}
