import 'weather_service.dart';

abstract class WeatherRepository {
  Future<WeatherData> getCurrentWeather({String? city});
  void clearCache();
}

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherService _weatherService;

  WeatherRepositoryImpl(this._weatherService);

  @override
  Future<WeatherData> getCurrentWeather({String? city}) async {
    return await _weatherService.fetchCurrentWeather(city: city);
  }

  @override
  void clearCache() {
    _weatherService.clearCache();
  }
}