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

  @override
  String get loginTitle => 'IoT Dashboard';

  @override
  String get loginSubtitle => 'Sign in to access your IoT devices';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get emailRequired => 'Please enter your email';

  @override
  String get passwordRequired => 'Please enter your password';

  @override
  String get emailInvalid => 'Please enter a valid email';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get signInButton => 'Sign In';

  @override
  String get loginFailed => 'Login failed. Please try again.';

  @override
  String get userNotFound => 'No user found with this email.';

  @override
  String get wrongPassword => 'Wrong password provided.';

  @override
  String get invalidEmail => 'Invalid email address.';

  @override
  String get userDisabled => 'This user account has been disabled.';

  @override
  String get tooManyRequests =>
      'Too many failed login attempts. Please try again later.';

  @override
  String get weakPassword => 'The password provided is too weak.';

  @override
  String get emailAlreadyInUse => 'An account already exists with that email.';

  @override
  String get registrationFailed => 'Registration failed. Please try again.';

  @override
  String get createAccount =>
      'Create an account or use existing Firebase credentials';

  @override
  String get logout => 'Logout';
}
