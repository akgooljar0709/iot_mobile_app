/// Exception thrown when the OpenWeatherMap API returns an error response
/// 
/// This exception includes the HTTP status code for proper error handling
/// and recovery strategies.
class WeatherApiException implements Exception {
  final String message;
  final int? statusCode;

  WeatherApiException(this.message, {this.statusCode});

  @override
  String toString() =>
      'WeatherApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Exception thrown when there's a network connectivity issue
/// 
/// This exception is used to distinguish network errors from API errors
/// and trigger automatic retry logic.
class WeatherNetworkException implements Exception {
  final String message;

  WeatherNetworkException(this.message);

  @override
  String toString() => 'WeatherNetworkException: $message';
}

/// Exception thrown when there's an unexpected error
class WeatherException implements Exception {
  final String message;

  WeatherException(this.message);

  @override
  String toString() => 'WeatherException: $message';
}
