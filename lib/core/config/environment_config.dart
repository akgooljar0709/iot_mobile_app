// Environment configuration
// Create a .env file in the root of your project and add your API keys there
// Example .env file:
// OPENWEATHERMAP_API_KEY=your_api_key_here

class EnvironmentConfig {
  static const String openWeatherMapApiKey = String.fromEnvironment(
    'OPENWEATHERMAP_API_KEY',
    defaultValue: 'f9a362f2b55ddb9656df793770a016a8',
  );
}