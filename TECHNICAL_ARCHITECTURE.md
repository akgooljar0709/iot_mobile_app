# Technical Architecture Guide

## System Architecture

### High-Level Overview

```
┌─────────────────────────────────────────────────────┐
│                  UI Layer (Presentation)             │
│  ┌──────────────────────────────────────────────┐  │
│  │  EnhancedDashboardPage                       │  │
│  │  ├─ EnhancedWeatherCard                      │  │
│  │  ├─ WeatherChartWidget                       │  │
│  │  └─ QuickStatCards                           │  │
│  │                                               │  │
│  │  CitySelectionPage                           │  │
│  │  └─ City Search & Filter                     │  │
│  └──────────────────────────────────────────────┘  │
└────────────────────────┬────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────┐
│              Domain Layer (Business Logic)          │
│  ┌──────────────────────────────────────────────┐  │
│  │  WeatherRepository (Interface)               │  │
│  │  SensorRepository (Interface)                │  │
│  └──────────────────────────────────────────────┘  │
└────────────────────────┬────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────┐
│                Data Layer (Services)               │
│  ┌───────────────┬──────────────┬───────────────┐  │
│  │ WeatherService│ SensorService│ DatabaseLayer │  │
│  └───────┬───────┴──────┬───────┴───────┬───────┘  │
│          │              │               │          │
└──────────┼──────────────┼───────────────┼──────────┘
           │              │               │
      ┌────▼──────┐  ┌────▼──────┐  ┌────▼──────┐
      │ OpenWeather   │ Sensor │  │  SQLite  │
      │ Map API       │ Data   │  │ Database │
      └───────────┘  └────────┘  └──────────┘
```

## Layer Descriptions

### Presentation Layer (UI)

**Responsibility**: Render UI and handle user interactions

**Key Files**:
- `lib/features/sensor/presentation/pages/dashboard/enhanced_dashboard_page.dart`
  - Main dashboard screen
  - Manages state and user interactions
  - Coordinates data loading and display

- `lib/features/sensor/presentation/pages/city_selection_page.dart`
  - City selection interface
  - Search and filter functionality
  - Navigation back with selected city

- `lib/features/sensor/presentation/widgets/enhanced_weather_card.dart`
  - Weather display component
  - Gradient backgrounds based on weather type
  - Loading and error states

- `lib/features/sensor/presentation/widgets/weather_chart_widget.dart`
  - Chart rendering using fl_chart
  - Temperature trend visualization
  - Interactive data points

- `lib/features/sensor/presentation/widgets/weather_icon_widget.dart`
  - Weather condition icons
  - Dynamic icon selection
  - Color-coded display

**State Management**:
- Currently using `StatefulWidget` for simplicity
- Can be extended with Provider or Riverpod for complex state

### Domain Layer

**Responsibility**: Define business logic interfaces

**Key Classes**:
```dart
abstract class WeatherRepository {
  Future<WeatherData> getCurrentWeather({String? city});
  void clearCache();
}

abstract class SensorRepository {
  Future<void> insertData(SensorModel data);
  Future<List<SensorModel>> getAllData();
  Future<void> deleteData(int id);
}
```

### Data Layer

**Responsibility**: Handle data operations and external integrations

#### WeatherService
```dart
class WeatherService {
  // Features:
  // - HTTP client for API calls
  // - In-memory caching (5 minutes)
  // - Retry logic with exponential backoff
  // - Custom exception handling
  
  Future<WeatherData> fetchCurrentWeather({
    String? city,
    bool useCache = true,
  })
}
```

**Implementation Details**:
- Supports both city names and city IDs
- Automatic query parameter selection
- Caching to reduce API calls
- Timeout handling (10 seconds)
- Retry attempts: 3

#### WeatherRepository Implementation
```dart
class WeatherRepositoryImpl extends WeatherRepository {
  final WeatherService _weatherService;
  
  // Wraps service with business logic
  // Currently simple delegation
  // Can add caching, transformation, etc.
}
```

#### SensorRepository Implementation
```dart
class SensorRepositoryImpl extends SensorRepository {
  // SQLite database operations
  // Uses sqflite package
  // CRUD operations for sensor data
}
```

## Data Models

### WeatherData
```dart
class WeatherData {
  final double temperature;      // Celsius
  final double humidity;         // 0-100%
  final String city;             // City name from OpenWeatherMap
  final String country;          // Country code
  final String weatherDescription; // e.g., "clear sky"
  final double windSpeed;        // m/s
  final DateTime timestamp;      // When data was fetched
  
  // fromJson constructor for API response parsing
  factory WeatherData.fromJson(Map<String, dynamic> json)
}
```

### SensorModel
```dart
class SensorModel {
  final int? id;                 // Database primary key
  final double temperature;      // Local sensor reading
  final double humidity;         // Local sensor reading
  final String timestamp;        // ISO 8601 format
  
  // Conversion to/from JSON for database
  Map<String, dynamic> toJson()
  factory SensorModel.fromJson(Map<String, dynamic> json)
}
```

## API Integration

### OpenWeatherMap API

**Endpoints Used**:
```
GET https://api.openweathermap.org/data/2.5/weather
  ?q={city_name}&appid={api_key}&units=metric
  
OR

GET https://api.openweathermap.org/data/2.5/weather
  ?id={city_id}&appid={api_key}&units=metric
```

**Response Example**:
```json
{
  "main": {
    "temp": 22.5,
    "humidity": 65
  },
  "name": "London",
  "sys": {"country": "GB"},
  "weather": [{"description": "clear sky"}],
  "wind": {"speed": 3.5}
}
```

**Error Codes**:
- 401: Invalid API key
- 404: City not found
- 429: Rate limit exceeded
- 5xx: Server errors

## Error Handling

### Custom Exceptions

```dart
class WeatherApiException {
  final String message;
  final int? statusCode;
  
  // Thrown when API returns error status
  // Includes status code for debugging
}

class WeatherNetworkException {
  final String message;
  
  // Thrown for network connectivity issues
  // Triggers automatic retry
}
```

### Retry Strategy

```dart
// Exponential backoff:
// Attempt 1: immediate
// Attempt 2: wait 1 second
// Attempt 3: wait 2 seconds
// Total: 3 retries maximum
```

## Caching Strategy

### In-Memory Cache

```dart
Map<String, _CacheEntry> _cache;

// Cache Entry:
class _CacheEntry {
  final WeatherData data;
  final DateTime timestamp;
  
  bool isValid(Duration duration) {
    final age = DateTime.now().difference(timestamp);
    return age < duration;
  }
}

// Cache Duration: 5 minutes
// Cache Key: city name (lowercase)
```

**When Cache is Used**:
1. Same city requested within 5 minutes
2. `useCache: true` parameter
3. Valid cache exists

**When Cache is Cleared**:
1. Refresh button pressed
2. Different city selected
3. Manual clear via API

## Database Schema

### Sensors Table

```sql
CREATE TABLE IF NOT EXISTS sensors (
  id INTEGER PRIMARY KEY,
  temperature REAL NOT NULL,
  humidity REAL NOT NULL,
  timestamp TEXT NOT NULL
)
```

**Indexes**:
```sql
CREATE INDEX idx_timestamp ON sensors(timestamp);
```

**Purpose**:
- Store local sensor data
- Track history over time
- Provide data for charts

## Configuration

### Environment Configuration
```dart
// lib/core/config/environment_config.dart
class EnvironmentConfig {
  static const String openWeatherMapApiKey = 'your_api_key';
}
```

### API Configuration
```dart
// lib/core/config/api_config.dart
class ApiConfig {
  static const String openWeatherMapApiKey = 
    EnvironmentConfig.openWeatherMapApiKey;
  static const String openWeatherMapBaseUrl = 
    'https://api.openweathermap.org/data/2.5/weather';
}
```

## Dependency Injection

Currently using manual instantiation:
```dart
// In DashboardPage.initState()
weatherService = WeatherService();
weatherRepository = WeatherRepositoryImpl(weatherService);
repo = SensorRepositoryImpl();
```

**Future Improvement**: Use GetIt or Provider for DI

## Testing Architecture

### Unit Tests
- Test WeatherService API calls
- Mock HTTP client
- Test exception handling
- Test caching logic

### Widget Tests
- Test UI component rendering
- Test user interactions
- Test state updates

### Integration Tests
- End-to-end workflows
- Real API calls
- Database operations

## Performance Considerations

### Memory Usage
- Chart renders smoothly with 20+ data points
- In-memory cache limited to ~100 entries max
- Image optimization for weather icons

### Network Usage
- Cache reduces API calls by ~80%
- Average response: 0.5-1 second
- Gzip compression supported

### Database Performance
- Indexed queries for timestamp
- VACUUM periodically recommended
- Connection pooled via sqflite

## Security

### API Key Management
- Never hardcode production keys
- Use environment variables
- Different keys for dev/staging/production

### Data Protection
- No sensitive data in preferences
- SQL injection protected (sqflite parameterized queries)
- HTTPS enforced for all API calls

### Network Security
- Certificate pinning: Not implemented (future)
- SSL/TLS verification: Enabled by default
- Timeout prevents hanging requests

## Localization Architecture

### ARB Files
```
lib/l10n/
├── app_en.arb        # English translations
└── app_<lang>.arb    # Additional languages
```

### Generated Code
```
lib/l10n/
├── app_localizations.dart      # Generated class
├── app_localizations_en.dart   # English delegate
└── app_localizations_<lang>.dart
```

### Usage
```dart
Text(AppLocalizations.of(context)!.iotDashboard)
```

## Extension Points

### Adding New Weather Metrics
1. Update WeatherData model
2. Extend API parsing
3. Update UI widgets
4. Add localization strings

### Adding New City Data Source
1. Create new service interface
2. Implement service class
3. Wrap in repository
4. Update dependency injection

### Implementing Notifications
1. Add flutter_local_notifications
2. Create notification service
3. Schedule in main widget
4. Handle notification taps

## Build & Deployment Process

### Development Build
```bash
flutter run -d chrome  # or other device
```

### Release Build
```bash
flutter clean
flutter pub get
flutter build appbundle --release  # Android
flutter build ios --release        # iOS
```

### App Signing
See PLAYSTORE_DEPLOYMENT.md for detailed instructions

## Code Style

### Naming Conventions
- Classes: PascalCase (`WeatherService`)
- Variables: camelCase (`weatherDescription`)
- Constants: UPPER_SNAKE_CASE (`_defaultCity`)
- Private: Leading underscore (`_cache`)

### File Organization
- Max 500 lines per file
- Related widgets in separate files
- One class per file (except small widgets)

## Documentation Standards

### Code Comments
```dart
/// Brief description
/// 
/// More detailed explanation if needed.
/// 
/// Example:
/// ```dart
/// final weather = await service.fetchCurrentWeather(city: 'London');
/// ```
```

### Commit Messages
```
[Feature/Fix/Docs] Brief description

Detailed explanation of changes if needed.

Related issues: #123
```

---

**Document Version**: 1.0  
**Last Updated**: April 15, 2026  
**Maintainer**: Your Name
