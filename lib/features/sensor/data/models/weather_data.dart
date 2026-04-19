/// Weather data model representing current weather conditions
/// 
/// This model encapsulates all relevant weather information fetched from
/// the OpenWeatherMap API and is used throughout the application.
class WeatherData {
  final double temperature;      // Celsius
  final double humidity;         // Percentage (0-100)
  final String city;             // City name
  final DateTime timestamp;      // When data was fetched
  final String country;          // Country code (e.g., 'GB', 'MU')
  final String weatherDescription; // Human-readable description
  final double windSpeed;        // m/s

  WeatherData({
    required this.temperature,
    required this.humidity,
    required this.city,
    required this.timestamp,
    required this.country,
    required this.weatherDescription,
    required this.windSpeed,
  });

  /// Creates WeatherData from JSON API response
  /// 
  /// Expected structure:
  /// ```json
  /// {
  ///   "main": {"temp": 25.5, "humidity": 65},
  ///   "name": "London",
  ///   "sys": {"country": "GB"},
  ///   "weather": [{"description": "clear sky"}],
  ///   "wind": {"speed": 3.5}
  /// }
  /// ```
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

  /// Converts WeatherData to JSON for storage/serialization
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

  @override
  String toString() => 'WeatherData(city: $city, temp: $temperature°C, '
      'humidity: $humidity%, wind: ${windSpeed}m/s, weather: $weatherDescription)';
}
