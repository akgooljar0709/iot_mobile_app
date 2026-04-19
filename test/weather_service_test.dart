import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:iot_mobile_app/features/sensor/data/datasources/weather_remote_datasource.dart';
import 'package:iot_mobile_app/features/sensor/domain/repositories/weather_repository_impl.dart';

void main() {
  group('WeatherRepository', () {
    late WeatherRepositoryImpl repository;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient((request) async {
        if (request.url.toString().contains('api.openweathermap.org')) {
          return http.Response('''
            {
              "main": {"temp": 28.5, "humidity": 75},
              "name": "Pamplemousses",
              "sys": {"country": "MU"},
              "weather": [{"description": "partly cloudy"}],
              "wind": {"speed": 4.2}
            }
          ''', 200);
        }
        return http.Response('Not Found', 404);
      });

      final dataSource = WeatherRemoteDataSourceImpl(httpClient: mockClient);
      repository = WeatherRepositoryImpl(remoteDataSource: dataSource);
    });

    test('getWeather returns valid WeatherData', () async {
      final weatherData = await repository.getWeather('Pamplemousses');

      expect(weatherData.temperature, 28.5);
      expect(weatherData.humidity, 75.0);
      expect(weatherData.city, 'Pamplemousses');
      expect(weatherData.country, 'MU');
      expect(weatherData.weatherDescription, 'partly cloudy');
      expect(weatherData.windSpeed, 4.2);
    });

    test('cache works correctly', () async {
      // First call
      final data1 = await repository.getWeather('Pamplemousses');
      expect(data1.temperature, 28.5);

      // Second call should use cache
      final data2 = await repository.getWeather('Pamplemousses');
      expect(data2.temperature, 28.5);

      // Should only have made one HTTP request due to caching
      expect(repository.cacheSize, 1);
    });
  });
}