// App-wide constants
class AppConstants {
  // Temperature threshold for alerts
  static const double temperatureThreshold = 30.0;

  // API/Network timeouts
  static const Duration apiTimeout = Duration(seconds: 10);
  static const int maxRetries = 3;

  // Cache settings
  static const Duration weatherCacheDuration = Duration(minutes: 5);

  // Auto-refresh interval
  static const Duration autoRefreshInterval = Duration(seconds: 30);

  // Chart settings
  static const int maxChartDataPoints = 20;

  // Database settings
  static const String sensorTableName = 'sensors';
  static const String sensorIdColumn = 'id';
  static const String sensorTemperatureColumn = 'temperature';
  static const String sensorHumidityColumn = 'humidity';
  static const String sensorTimestampColumn = 'timestamp';
}
