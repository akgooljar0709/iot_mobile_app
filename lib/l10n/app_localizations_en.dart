// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get iotDashboard => 'Weather Monitor';

  @override
  String get temperature => 'Temperature';

  @override
  String get humidity => 'Humidity';

  @override
  String get coolingSystemActivated => 'High Temperature Alert';

  @override
  String get normal => 'Normal Conditions';

  @override
  String get sensorHistory => 'Sensor History';

  @override
  String get noHistory => 'No saved readings yet';

  @override
  String get refresh => 'Refresh';

  @override
  String get viewHistory => 'View History';

  @override
  String get selectCity => 'Select City';

  @override
  String get weatherData => 'Weather Data';

  @override
  String get windSpeed => 'Wind Speed';

  @override
  String get temperatureTrend => 'Temperature Trend';

  @override
  String get averageTemperature => 'Average Temperature';

  @override
  String get dataPoints => 'Data Points';

  @override
  String get highTemperature => 'High Temperature';

  @override
  String get temperatureExceeded => 'Temperature threshold exceeded';

  @override
  String get allConditionsNormal => 'All conditions are normal';

  @override
  String get searchCities => 'Search cities...';

  @override
  String get noCitiesFound => 'No cities found';

  @override
  String get selectLocationMap => 'Select Location on Map';

  @override
  String get realTimeData => 'Real-time Data';

  @override
  String get errorApiKeyNotConfigured =>
      'API key not configured. Please set your OpenWeatherMap API key.';

  @override
  String get errorInvalidApiKey =>
      'Invalid API key. Please check your OpenWeatherMap configuration.';

  @override
  String get errorCityNotFound =>
      'Location not found. Please try a different location.';

  @override
  String get errorRateLimitExceeded =>
      'API rate limit exceeded. Please try again later.';

  @override
  String get errorNetworkConnection =>
      'Network error. Please check your internet connection.';

  @override
  String get errorRequestTimeout =>
      'Request timeout. Please check your connection.';

  @override
  String get errorUnexpected =>
      'An unexpected error occurred. Please try again.';

  @override
  String get errorFailedFetchWeather => 'Failed to fetch weather data';

  @override
  String get errorFailedFetchAfterRetries =>
      'Failed to fetch weather after multiple attempts';

  @override
  String get retryingAutomatically => 'Retrying automatically...';

  @override
  String get noDataAvailable => 'No data available';
}
