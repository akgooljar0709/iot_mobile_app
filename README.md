# 📱 IoT Weather Monitor - AIoT Mobile App

A sophisticated Flutter application that provides intelligent IoT (Internet of Things) monitoring with AI capabilities, real-time data visualization, and Arduino integration. The app collects sensor data, applies machine learning algorithms for predictive analysis, monitors Arduino real-time data, and provides comprehensive environmental tracking.

---

## 🚀 Key Features

### 🏠 Enhanced Dashboard
- **Real-time sensor monitoring**: Temperature, humidity, and wind speed from weather APIs
- **Weather-based icons**: Dynamic weather condition icons
- **City selection**: Browse and select from 15+ major cities worldwide
- **Sensor history**: Track and visualize historical temperature data
- **AI-powered analysis**: AIoT predictions and anomaly detection
- **Quick statistics**: Average temperature and data point count
- **Visual status indicators**: Color-coded alerts (Green = Normal, Red = Critical)

### 🔌 Arduino Real-Time Monitoring (NEW)
- **Dedicated Arduino Page**: Separate page for real-time Arduino sensor data
- **Live Temperature Display**: Large, prominent temperature reading from Arduino
- **Connection Status**: Visual indicator showing connection state (green/red dot)
- **Real-time Updates**: Automatic updates as data arrives from Arduino
- **Manual Refresh**: Tap to refresh data on demand
- **Pull-to-Refresh**: Standard refresh gesture support
- **Auto-Reconnection**: Automatically attempts to reconnect on connection loss
- **Status Information**: Last update time and timestamp display

### 🤖 Advanced AIoT Capabilities
- **Predictive Analytics**: Forecasts next temperature values using historical data
- **Smart Anomaly Detection**: Identifies outliers using statistical analysis (Z-score)
- **Trend Recognition**: Analyzes data patterns to detect temperature trends (Rising/Falling/Stable)
- **Intelligent Recommendations**: Suggests optimal threshold values based on usage patterns
- **Offline Simulation**: Continues functioning with local data generation when network is unavailable

### 💾 Robust Data Management
- **SQLite Storage**: Local database for sensor readings and app settings
- **Historical Data**: Complete record of all sensor measurements
- **Settings Persistence**: Remembers user preferences and thresholds
- **Data Visualization**: Interactive charts showing temperature trends
- **Firebase Real-time Database**: Cloud sync for Arduino data

### 🔐 Authentication & Security
- **Firebase Authentication**: Secure user login/signup
- **Email/Password Auth**: Create account with email verification
- **Password Reset**: Forgot password recovery feature
- **Session Management**: Auto-logout and session handling

### ⚙️ User Experience
- **Theme Support**: Light and dark mode with system preference detection
- **Multi-language**: English localization support (extensible)
- **Responsive Design**: Optimized for mobile devices
- **Settings Management**: Easy configuration of alert thresholds
- **Intuitive Navigation**: Bottom navigation with quick access to all features

---

## 📊 Application Pages

1. **Login Page** - User authentication with email/password
2. **Sign Up Page** - New user registration
3. **Forgot Password Page** - Password recovery
4. **Enhanced Dashboard** - Main weather and sensor monitoring
5. **Arduino Real-Time Page** - Live Arduino sensor monitoring
6. **City Selection Page** - Browse and select cities
7. **Sensor History Page** - View historical sensor data
8. **Settings Page** - Configure alert thresholds and preferences

---

## 🛠️ Technology Stack

- **Framework**: Flutter 3.9+ with Dart 3.9.2
- **State Management**: StatefulWidget with Provider pattern
- **Database**: SQLite via sqflite package
- **Cloud**: Firebase (Auth, Realtime Database)
- **Networking**: HTTP client and Firebase SDK
- **AI/ML**: Custom algorithms for predictive analytics
- **UI**: Material Design 3 with custom widgets
- **Charts**: fl_chart for data visualization
- **Internationalization**: Flutter localization framework
- **MQTT**: mqtt_client for IoT communication
- **Fonts**: Google Fonts integration

---

## 📋 Prerequisites

- Flutter SDK (3.9.0 or higher)
- Dart SDK (3.9.2 or higher, included with Flutter)
- Android Studio or VS Code with Flutter extensions
- Android/iOS device or emulator
- **Firebase Account**: Required for authentication and real-time data features
- **OpenWeatherMap API Key**: For weather data (optional, has demo key)

---

## 🚀 Installation & Setup

### 1. Clone the Repository
```bash
git clone <repository-url>
cd iot_mobile_app
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Firebase Setup
The app uses Firebase for authentication and real-time Arduino data. Follow these steps:

1. **Create a Firebase Project**:
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Click "Create a project" or select an existing one
   - Enable Authentication and configure sign-in methods (Email/Password)
   - Enable Realtime Database for Arduino data sync

2. **Configure Firebase for your platform**:
   ```bash
   # Install FlutterFire CLI (if not already installed)
   dart pub global activate flutterfire_cli

   # Configure Firebase for your project
   flutterfire configure
   ```
   This will automatically generate the `firebase_options.dart` file with your project configuration.

3. **Manual Configuration** (Alternative):
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) from Firebase Console
   - Place them in the respective platform directories:
     - Android: `android/app/google-services.json`
     - iOS: `ios/Runner/GoogleService-Info.plist`
   - Update `lib/firebase_options.dart` with your Firebase project configuration

4. **Set up Realtime Database**:
   - In Firebase Console, create a Realtime Database
   - Set database rules for Arduino data access
   - Configure the database URL in your Firebase project

### 4. Configure Weather API (Optional)
The app includes a demo API key for testing. For production use:

1. Get a free API key from [OpenWeatherMap](https://openweathermap.org/api)
2. Create a `.env` file in the root directory:
   ```
   OPENWEATHERMAP_API_KEY=your_actual_api_key_here
   ```

### 5. Run the Application
```bash
# For Android
flutter run

# For iOS (macOS only)
flutter run --device-id=<ios-device-id>

# For Web
flutter run -d chrome
```

---

## 📱 Usage Guide

### First Launch
1. **Authentication Required**: The app starts with a login screen
2. **Create Account**: Use any valid email and password (minimum 6 characters)
3. **Login**: Use your registered email and password to access the dashboard
4. Initial sensor data loads automatically after login
5. AI analysis begins processing historical data

### Dashboard Navigation
The enhanced dashboard includes multiple icons in the app bar for easy access:

**Icon Legend** (Left to Right):
- ⚙️ **Settings** - Configure threshold and theme preferences
- 📍 **City Selection** - Browse and select weather monitoring city
- 🔄 **Refresh** - Manually refresh weather data
- 📊 **History** - View historical sensor data
- 🔌 **Arduino Real-Time** (Cable icon) - Access Arduino monitoring page
- 🚪 **Logout** - Sign out and return to login

### Dashboard Features
- **Weather Card**: Shows current temperature, humidity, and weather conditions
- **Status Indicator**: Shows system status with color-coded alerts
  - Green = Normal conditions
  - Red = Temperature exceeds threshold (cooling system activated)
- **AIoT Analysis Section**: Displays:
  - Predicted Temperature - Next predicted temperature using ML
  - Trend - Temperature trend (Hausse/Baisse/Stable)
  - Anomaly Detection - Shows if anomalies are detected
  - Recommended Threshold - AI-suggested alert threshold
- **Temperature Chart**: Interactive line chart showing temperature trends over time
- **Quick Stats**: Average temperature and total data points

### Arduino Real-Time Monitoring
Access the dedicated Arduino monitoring page by tapping the cable icon (🔌) in the dashboard:

**Features**:
- **Large Temperature Display**: Prominent thermometer icon with current Arduino temperature reading
- **Connection Status**: Live indicator showing connection state
  - Green dot = Connected and receiving data
  - Red dot = Disconnected
- **Status Information**:
  - Connection status (Connected/Disconnected)
  - Last update time (relative, e.g., "5s ago")
  - Full timestamp of last reading
- **Manual Refresh**: Tap "Refresh Now" button to manually fetch latest data
- **Pull-to-Refresh**: Pull down gesture for quick refresh
- **Auto-Reconnection**: Automatically attempts reconnection if connection is lost

### Settings Configuration
1. Tap the settings icon (⚙️) in the app bar
2. **Temperature Threshold**: Set alert threshold (default: 30°C)
3. **Theme**: Choose between Light, Dark, or System preference
4. Changes are saved automatically

### Data History
1. Tap the history icon (📊) in the app bar
2. View all recorded sensor readings with timestamps
3. Scroll through historical data
4. Data persists in SQLite database

### City Selection
1. Tap the location icon (📍) in the app bar
2. **Search Bar**: Type to filter cities by name or country
3. **City Grid**: Select from popular cities worldwide
4. **Current Selection**: Indicated with checkmark
5. Weather data updates automatically for selected location
6. Supported cities include:
   - Pamplemousses, Mauritius (Default)
   - Port Louis, Mauritius
   - London, United Kingdom
   - New York, USA
   - Tokyo, Japan
   - Paris, France
   - Dubai, UAE
   - Sydney, Australia
   - And more...

### Logout
1. Tap the logout icon (🚪) in the app bar
2. Returns to the login screen
3. Authentication state is cleared
4. All session data is preserved

---

## 🏗️ Project Structure

```
lib/
├── core/                          # Core utilities and constants
│   ├── config/                    # Configuration files
│   ├── constants/
│   │   └── colors.dart           # App color scheme
│   └── utils/
│
├── features/                      # Feature modules
│   ├── auth/                      # Authentication feature
│   │   ├── data/
│   │   │   └── auth_service.dart
│   │   └── presentation/
│   │       └── pages/
│   │           ├── login_page.dart
│   │           ├── signup_page.dart
│   │           └── forgot_password_page.dart
│   │
│   └── sensor/                    # Sensor monitoring feature
│       ├── data/                  # Data layer
│       │   ├── realtime_database_service.dart    # Firebase real-time data
│       │   ├── sensor_model.dart
│       │   ├── sensor_repository_impl.dart
│       │   ├── weather_service.dart
│       │   ├── weather_repository.dart
│       │   ├── ai_service.dart
│       │   ├── settings_repository.dart
│       │   └── settings_model.dart
│       │
│       ├── domain/                # Domain layer (interfaces)
│       │   └── repositories/
│       │
│       └── presentation/          # UI layer
│           ├── pages/
│           │   ├── dashboard/
│           │   │   ├── enhanced_dashboard_page.dart      # Main dashboard
│           │   │   ├── dashboard_page.dart
│           │   │   └── modern_dashboard_page.dart
│           │   ├── realtime_arduino_page.dart            # Arduino real-time (NEW)
│           │   ├── realtime_arduino_graph_page.dart
│           │   ├── arduino_data_menu_page.dart
│           │   ├── city_selection_page.dart
│           │   ├── sensor_history_page.dart
│           │   ├── settings_page.dart
│           │   └── arduino_temperature_page.dart
│           │
│           ├── providers/         # State management
│           └── widgets/           # Reusable UI components
│               ├── enhanced_weather_card.dart
│               ├── sensor_card.dart
│               ├── weather_chart_widget.dart
│               ├── weather_icon_widget.dart
│               └── status_text.dart
│
├── l10n/                          # Localization
│   ├── app_en.arb
│   └── app_localizations.dart
│
├── firebase_options.dart          # Firebase configuration
├── main.dart                      # App entry point
└── pubspec.yaml                   # Dependencies
```

---

## 🏗️ Architecture Overview

The application follows **Clean Architecture** principles:

### Layer Structure

```
┌─────────────────────────────────────┐
│    Presentation Layer (UI)          │
│  - Pages, Widgets, State Management │
└────────────────┬────────────────────┘
                 │
┌────────────────▼────────────────────┐
│    Domain Layer (Business Logic)    │
│  - Interfaces, Use Cases            │
└────────────────┬────────────────────┘
                 │
┌────────────────▼────────────────────┐
│    Data Layer (Services)            │
│  - Repositories, External Services  │
└─────────────────────────────────────┘
       │          │          │
       ▼          ▼          ▼
    SQLite   Firebase   OpenWeatherMap
   Database   Database      API
```

### Key Components

| Component | Purpose |
|-----------|---------|
| **WeatherService** | Fetches weather data from OpenWeatherMap API with caching |
| **RealtimeDatabaseService** | Manages Firebase real-time connections for Arduino data |
| **AIService** | Implements ML algorithms for predictions and anomaly detection |
| **SensorRepositoryImpl** | Handles SQLite database operations for sensor data |
| **SettingsRepository** | Manages persistent user settings |
| **AuthService** | Manages Firebase authentication |

---

## 🤖 AIoT Implementation

### 1. Predictive Temperature Model
```dart
// Linear regression on last 10 readings
double predictNextTemperature() {
  // Calculates slope and intercept
  // Applies bounds checking (0°C to 50°C)
  // Returns predicted next value
}
```

**Algorithm**:
- Collects last 10 historical readings
- Fits linear trend line (y = mx + b)
- Extrapolates one step forward
- Bounds result to realistic range

### 2. Anomaly Detection
```dart
// Z-score based anomaly detection
bool detectAnomaly() {
  // Computes mean and standard deviation
  // Calculates Z-score for latest reading
  // Returns true if |z-score| > 2
}
```

**Algorithm**:
- Uses statistical approach (σ-sigma rule)
- Threshold: |Z| > 2 (95% confidence)
- Real-time evaluation of new readings
- Adapts to historical data distribution

### 3. Trend Analysis
```dart
// Compares recent vs historical averages
String getTrend() {
  // Rising (Hausse): Recent avg > historical avg
  // Falling (Baisse): Recent avg < historical avg  
  // Stable: Similar averages
}
```

### 4. Smart Thresholds
```dart
// Recommends optimal alert threshold
double recommendThreshold() {
  // Analyzes 95th percentile of historical data
  // Suggests threshold avoiding false positives
  // Balances safety with sensitivity
}
```

---

## 📡 Arduino Real-Time Integration

### Firebase Real-Time Database Structure
```
firebase_root/
├── arduino/
│   ├── temperature
│   ├── humidity
│   ├── sensors/
│   │   ├── sensor1
│   │   └── sensor2
│   └── lastUpdate
```

### RealtimeDatabaseService Features
- **Real-time Streams**: Listens to Firebase for live updates
- **Auto-Reconnection**: Attempts reconnection on disconnect
- **Error Handling**: Graceful handling of connection errors
- **Data Parsing**: Converts Firebase data to usable format

### Arduino Page Implementation
1. Initializes Firebase connection on page load
2. Subscribes to temperature stream
3. Updates UI with real-time data
4. Displays connection status
5. Handles reconnection automatically
6. Provides manual refresh option

---

## 📊 Data Flow

```
┌─────────────────────────────────────────────────┐
│ 1. DATA COLLECTION                              │
│    - Weather API fetch                          │
│    - Arduino real-time stream                   │
│    - Sensor readings                            │
└───────────────────┬─────────────────────────────┘
                    │
┌───────────────────▼─────────────────────────────┐
│ 2. DATA STORAGE                                 │
│    - SQLite (local readings)                    │
│    - Firebase (Arduino data)                    │
│    - Shared Preferences (settings)              │
└───────────────────┬─────────────────────────────┘
                    │
┌───────────────────▼─────────────────────────────┐
│ 3. AI PROCESSING                                │
│    - Predictive analytics                       │
│    - Anomaly detection                          │
│    - Trend analysis                             │
│    - Threshold optimization                     │
└───────────────────┬─────────────────────────────┘
                    │
┌───────────────────▼─────────────────────────────┐
│ 4. UI UPDATES                                   │
│    - Dashboard display                          │
│    - Alert notifications                        │
│    - Status indicators                          │
│    - Chart visualizations                       │
└─────────────────────────────────────────────────┘
```

---

## 🔧 Development Guide

### Running the Application
```bash
# Standard run
flutter run

# With specific device
flutter run -d <device-id>

# Release build
flutter run --release

# Debug with verbose logging
flutter run -v
```

### Building for Production

**Android APK**
```bash
flutter build apk --release
# Output: build/app/release/app-release.apk
```

**Android App Bundle**
```bash
flutter build appbundle --release
# Output: build/app/release/app-release.aab (for Play Store)
```

**iOS**
```bash
flutter build ios --release
# Requires macOS
```

### Code Generation
```bash
# Generate localization files
flutter gen-l10n

# Build runner
flutter pub run build_runner build

# Build with --delete-conflicting-outputs if needed
flutter pub run build_runner build --delete-conflicting-outputs
```

### Running Tests
```bash
# All tests
flutter test

# Specific test file
flutter test test/widget_test.dart

# With coverage
flutter test --coverage
```

---

## 🐛 Troubleshooting

### Arduino Page Shows Blank Screen
- **Cause**: Stream subscription not initialized properly
- **Solution**: Ensure nullable stream subscriptions with `?` operator
- **Check**: Firebase connection and Realtime Database configuration

### "Network Error" Message
- **Cause**: No internet or API rate limit exceeded
- **Solution**: 
  - Check internet connection
  - Verify API key in Firebase config
  - App has offline mode with simulated data

### AI Predictions Not Showing
- **Cause**: Insufficient historical data (< 2 readings)
- **Solution**: App needs to run for a few minutes to collect data
- **Debug**: Check AI service logs

### Settings Not Persisting
- **Cause**: Shared preferences not initialized or permission issue
- **Solution**: 
  - Clear app cache and data
  - Verify storage permissions
  - Restart application

### Theme Changes Not Applied
- **Cause**: UI not rebuilt after settings change
- **Solution**: 
  - Restart the app
  - Try toggling theme twice
  - Check `ThemeMode` setting

### Firebase Authentication Issues
- **Cause**: Incorrect Firebase configuration
- **Solution**:
  - Re-run `flutterfire configure`
  - Verify `google-services.json` in correct location
  - Check Firebase Console for enabled auth methods

---

## 🔐 Security Considerations

1. **Firebase Security Rules**: Implement proper Realtime Database rules
2. **API Key Management**: Keep API keys in environment variables
3. **Authentication**: Use Firebase secure authentication
4. **Data Validation**: Validate all inputs before storage
5. **Permissions**: Request only necessary Android/iOS permissions

---

## 📈 Performance Optimization

- **Caching**: 5-minute weather API cache to reduce calls
- **Lazy Loading**: Charts load only when needed
- **Stream Optimization**: Efficient Firebase real-time streams
- **Database Indexing**: Optimized SQLite queries
- **Memory Management**: Proper disposal of subscriptions and resources

---

## 📈 Future Enhancements

- [ ] Push notifications for critical alerts
- [ ] Advanced ML models (TensorFlow Lite)
- [ ] Multi-device sensor network support
- [ ] Data export functionality (CSV/PDF)
- [ ] Advanced analytics dashboard
- [ ] Voice commands integration
- [ ] Predictive maintenance alerts
- [ ] Energy consumption tracking

---

## 📄 License

This project is developed for educational and demonstration purposes.

---

## 👨‍💻 Support & Documentation

- **Flutter Docs**: https://flutter.dev/docs
- **Firebase Docs**: https://firebase.google.com/docs
- **OpenWeatherMap API**: https://openweathermap.org/api
- **fl_chart Documentation**: https://github.com/imaNNeoFighT/fl_chart

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

**Last Updated**: April 2026
**App Version**: 1.0.0