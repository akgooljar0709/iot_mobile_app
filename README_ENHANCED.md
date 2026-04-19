# IoT Weather Monitor - Enhanced Edition

A professional Flutter weather application with real-time data, beautiful visualizations, and intuitive location selection.

## ✨ Features

### 🌤️ Real-Time Weather Data
- Fetch current weather conditions using OpenWeatherMap API
- Display temperature, humidity, and wind speed
- Weather-specific icons (sunny, rainy, cloudy, stormy, etc.)
- Automatic refresh every 30 seconds
- Smart caching to reduce API calls

### 📊 Data Visualization
- **Temperature Charts**: Track temperature trends over time with beautiful line charts
- **Quick Statistics**: View average temperature and data point count
- **Historical Data**: Store and display up to 20 recent readings
- **Real-time Updates**: Charts update automatically as new data arrives

### 📍 City Management
- **City Selection**: Browse and select from 15 major cities worldwide
- **Search Functionality**: Quick search for cities by name or country
- **Popular Cities**: Pre-loaded list including:
  - Pamplemousses, Mauritius (Default)
  - Port Louis, Mauritius
  - London, United Kingdom
  - New York, USA
  - Tokyo, Japan
  - Paris, France
  - Dubai, UAE
  - And more...

### 🚨 Smart Alerts
- Real-time temperature threshold monitoring (default: 30°C)
- Visual status indicators for normal and high-temperature states
- Color-coded alert system

### 🌍 Localization
- English language support
- Easy to extend with additional languages
- Localized weather descriptions

### 💾 Data Storage
- SQLite database for local storage
- Automatic sensor data logging
- Historical data persistence

## 📱 UI Components

### EnhancedWeatherCard
Beautiful gradient card displaying:
- Current weather icon
- City name and description
- Temperature, humidity, and wind speed
- Loading and error states

### WeatherChartWidget
Interactive line chart showing:
- Temperature trends
- Dynamic scaling based on data range
- Smooth curves and area gradients
- Responsive to screen size

### CitySelectionPage
User-friendly city selection interface:
- Search bar with clear button
- Grid/card listing of cities
- Selected city indicator
- Country information display

### QuickStatCards
Dashboard summary widgets:
- Average temperature calculation
- Data point visualization
- Color-coded by metric type

## 🏗️ Architecture

### Layer Structure
```
lib/
├── core/
│   ├── config/           # API and environment configuration
│   └── constants/        # App-wide constants (colors, etc.)
├── features/
│   └── sensor/
│       ├── data/         # Data layer (API, repository, models)
│       ├── domain/       # Business logic
│       └── presentation/ # UI layer (pages, widgets)
└── l10n/                 # Localization files
```

### Key Classes

**WeatherService**: Handles API communication with:
- Automatic retry logic (3 attempts)
- In-memory caching (5-minute duration)
- Exponential backoff for retries
- Custom exception handling

**WeatherRepository**: Abstraction layer for weather data

**SensorRepositoryImpl**: SQLite database operations

**Enhanced Dashboard**: Main UI with all new features

## 🔧 Dependencies

- **fl_chart**: Professional charting library
- **http**: HTTP client for API calls
- **sqflite**: SQLite database
- **google_maps_flutter**: Map integration (prepared)
- **geolocator**: Location services (prepared)
- **geocoding**: Address to coordinates (prepared)
- **weather_icons**: Weather-specific icons (prepared)
- **intl**: Internationalization
- **google_fonts**: Custom fonts

## 🚀 Quick Start

### Prerequisites
- Flutter 3.9.2 or higher
- Dart 3.9.2 or higher
- OpenWeatherMap API key (free at openweathermap.org)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd iot_mobile_app
```

2. Install dependencies:
```bash
flutter pub get
flutter gen-l10n
```

3. Set API Key:
Update `lib/core/config/environment_config.dart`:
```dart
static const String openWeatherMapApiKey = 'YOUR_API_KEY';
```

4. Run the app:
```bash
flutter run
```

## 🔑 API Integration

### OpenWeatherMap
- **Endpoint**: `https://api.openweathermap.org/data/2.5/weather`
- **Features Used**: Current weather by city name
- **Free Tier**: 1000 calls/day
- **Response Time**: <1 second typical

### Error Handling
- 401: Invalid API key
- 404: City not found
- 429: Rate limit exceeded
- Network errors: Automatic retry with exponential backoff

## 📊 Data Models

### WeatherData
```dart
final double temperature;      // Celsius
final double humidity;         // Percentage
final String city;             // City name
final String country;          // Country code
final String weatherDescription; // Weather condition
final double windSpeed;        // m/s
final DateTime timestamp;      // Measurement time
```

### SensorModel
```dart
final int id;                  // Database ID
final double temperature;      // Celsius
final double humidity;         // Percentage
final String timestamp;        // ISO 8601 format
```

## 🎨 Theming

### Color Scheme
- Primary: Blue gradient (custom MaterialColor)
- Weather conditions: Dynamic gradients
  - Sunny: Orange/Amber
  - Cloudy: Light Blue
  - Rainy: Deep Blue
  - Stormy: Purple/Dark
  - Snowy: Light Blue

### Responsive Design
- Adapts to all screen sizes
- Optimized for phones and tablets
- Touch-friendly UI elements

## 🧪 Testing

### Unit Tests
```bash
flutter test test/weather_service_test.dart
```

### Widget Tests
Test UI components independently

### Integration Tests
Test complete user workflows

## 📈 Performance Optimizations

1. **Caching**: 5-minute cache for API responses
2. **Lazy Loading**: Charts render only when visible
3. **Database Indexing**: Optimized SQLite queries
4. **Memory Management**: Proper dispose of resources
5. **Network Optimization**: Exponential backoff for retries

## 🔐 Security

- API key managed via environment configuration
- HTTPS for all API calls
- No sensitive data stored in preferences
- Database integrity checks

## 📝 Localization

Currently supported:
- English (en)

To add new languages:
1. Create `lib/l10n/app_<language_code>.arb`
2. Add translations
3. Run `flutter gen-l10n`
4. Update `supportedLocales` in main.dart

## 🐛 Known Limitations

1. Google Maps integration prepared but not fully implemented
2. Location-based city selection ready for implementation
3. Offline mode uses cached data only
4. Maximum 20 historical data points displayed in charts

## 🚀 Future Enhancements

- [ ] Map-based location picker
- [ ] 7-day weather forecast
- [ ] Weather alerts and notifications
- [ ] Multiple location tracking
- [ ] Dark mode support
- [ ] Offline caching
- [ ] Weather history export
- [ ] Push notifications
- [ ] Widget support
- [ ] Wear OS integration

## 📄 Building for Production

### Android
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

See PLAYSTORE_DEPLOYMENT.md for complete deployment instructions.

## 📞 Support

For issues or feature requests:
1. Check the documentation
2. Review error messages in console
3. Check OpenWeatherMap API status
4. Verify network connectivity

## 📄 License

[Add your license here]

## 👨‍💻 Contributors

- Initial development: Your Name
- Enhanced UI/UX: GitHub Copilot Assistant

---

**Version**: 1.0.0  
**Last Updated**: April 15, 2026  
**Status**: Production Ready
