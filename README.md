# 📱 IoT Weather Monitor - AIoT Mobile App

A sophisticated Flutter application that simulates an intelligent IoT (Internet of Things) environment with AI capabilities. The app collects sensor data, applies machine learning algorithms for predictive analysis, and provides real-time monitoring with automated alerts.

---

## 🚀 Key Features

### 🏠 Enhanced Dashboard
- **Real-time sensor monitoring**: Temperature, humidity, and wind speed
- **AI-powered predictions**: Next temperature prediction using linear regression
- **Anomaly detection**: Automatic identification of abnormal sensor readings
- **Trend analysis**: Detection of rising/falling/stable temperature trends
- **Dynamic thresholds**: AI-recommended alert thresholds based on historical data
- **Visual status indicators**: Color-coded alerts (Green = Normal, Red = Critical)

### 🤖 Advanced AIoT Capabilities
- **Predictive Analytics**: Forecasts next temperature values using historical data
- **Smart Anomaly Detection**: Identifies outliers using statistical analysis (Z-score)
- **Trend Recognition**: Analyzes data patterns to detect temperature trends
- **Intelligent Recommendations**: Suggests optimal threshold values based on usage patterns
- **Offline Simulation**: Continues functioning with local data generation when network is unavailable

### 💾 Robust Data Management
- **SQLite Storage**: Local database for sensor readings and app settings
- **Historical Data**: Complete record of all sensor measurements
- **Settings Persistence**: Remembers user preferences and thresholds
- **Data Visualization**: Interactive charts showing temperature trends

### ⚙️ User Experience
- **Theme Support**: Light and dark mode with system preference detection
- **Multi-language**: English localization support
- **Responsive Design**: Optimized for mobile devices
- **Settings Management**: Easy configuration of alert thresholds and preferences

---

## 🛠️ Technology Stack

- **Framework**: Flutter 3.9+ with Dart
- **State Management**: Provider pattern with service locator
- **Database**: SQLite via sqflite package
- **Networking**: HTTP client for API communication
- **AI/ML**: Custom algorithms for predictive analytics
- **UI**: Material Design 3 with custom widgets
- **Internationalization**: Flutter localization framework

---

## 📋 Prerequisites

- Flutter SDK (3.9.0 or higher)
- Dart SDK (included with Flutter)
- Android Studio or VS Code with Flutter extensions
- Android/iOS device or emulator

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

### 3. Configure API (Optional)
The app includes a demo API key for testing. For production use:

1. Get a free API key from [OpenWeatherMap](https://openweathermap.org/api)
2. Create a `.env` file in the root directory:
   ```
   OPENWEATHERMAP_API_KEY=your_actual_api_key_here
   ```

### 4. Run the Application
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
1. The app starts directly on the dashboard
2. Initial sensor data loads automatically
3. AI analysis begins processing historical data

### Dashboard Features
- **Weather Card**: Shows current temperature, humidity, and weather conditions
- **AI Predictions**: Displays predicted next temperature and trend analysis
- **Status Indicator**: Shows system status with color-coded alerts
- **Quick Stats**: Average temperature and total data points

### Settings Configuration
1. Tap the settings icon (⚙️) in the app bar
2. Adjust temperature threshold for alerts
3. Toggle between light and dark themes
4. Changes are saved automatically

### Data History
1. Tap the history icon (📊) in the app bar
2. View all recorded sensor readings
3. Scroll through historical data with timestamps

### City Selection
1. Tap the location icon (📍) in the app bar
2. Search and select different cities
3. Weather data updates for the selected location

---

## 🏗️ Architecture Overview

### Clean Architecture Pattern
```
lib/
├── core/                 # Core utilities and constants
├── features/            # Feature-based modules
│   ├── sensor/          # Main IoT sensor functionality
│   │   ├── data/        # Data layer (repositories, models, services)
│   │   ├── domain/      # Domain layer (business logic)
│   │   └── presentation/# UI layer (pages, widgets)
└── l10n/               # Localization files
```

### Key Components
- **WeatherService**: Handles API communication and caching
- **AIService**: Implements AI algorithms for predictions and analysis
- **SensorLocalDB**: SQLite database management
- **SettingsRepository**: Persistent settings storage
- **EnhancedDashboardPage**: Main UI with AI features

---

## 🤖 AIoT Implementation Details

### Predictive Temperature Model
- Uses linear regression on last 10 readings
- Calculates slope and intercept for trend prediction
- Applies bounds checking (0°C to 50°C)

### Anomaly Detection
- Computes mean and standard deviation
- Uses Z-score analysis (>2σ = anomaly)
- Real-time monitoring of sensor readings

### Trend Analysis
- Compares recent vs. historical averages
- Classifies as: Rising, Falling, or Stable
- Updates every sensor reading cycle

### Smart Thresholds
- Analyzes historical maximum values
- Recommends thresholds based on usage patterns
- Balances safety with false positive reduction

---

## 🔧 Development

### Running Tests
```bash
flutter test
```

### Building for Production
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (macOS only)
flutter build ios --release
```

### Code Generation
```bash
# Generate localization files
flutter gen-l10n

# Build assets
flutter pub run build_runner build
```

---

## 📊 Data Flow

1. **Sensor Data Collection**: App fetches weather data from OpenWeatherMap API
2. **Local Storage**: Data saved to SQLite database with timestamps
3. **AI Processing**: Historical data analyzed for patterns and predictions
4. **UI Updates**: Dashboard displays current data, predictions, and alerts
5. **Settings Integration**: User preferences affect threshold calculations

---

## 🐛 Troubleshooting

### Common Issues

**App shows "Network Error"**
- Check internet connection
- Verify API key in `.env` file
- App will simulate local data if network unavailable

**AI predictions not showing**
- Ensure at least 2 historical readings exist
- Check app logs for AI service errors

**Settings not saving**
- Verify app has storage permissions
- Check SQLite database initialization

**Dark mode not working**
- Ensure system supports theme switching
- Restart app after theme change

---

## 📈 Future Enhancements

- [ ] Push notifications for critical alerts
- [ ] Advanced ML models (TensorFlow Lite integration)
- [ ] Multi-device sensor network support
- [ ] Cloud synchronization with Firebase
- [ ] Energy consumption optimization
- [ ] Historical data export functionality

---

## 📄 License

This project is developed for educational and demonstration purposes.

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

---
```bash
flutter run
```

Or with custom environment variables:
```bash
flutter run --dart-define=OPENWEATHERMAP_API_KEY=your_key_here
```

### API Features
- ✅ Real-time weather data (temperature, humidity)
- ✅ Automatic caching (5-minute intervals)
- ✅ Retry logic for failed requests
- ✅ Network error handling
- ✅ Rate limit detection

---

## 📂 Project Structure
lib/
├── core/
│ ├── constants/
│ ├── i10n/
│
├── features/
│ └── sensor/
│ ├── data/
│ ├── domain/
│ ├── presentation/
│
└── main.dart


### Explanation:
- **core/** → Shared resources (constants, configs)
- **data/** → Models, database, repositories
- **domain/** → Business logic & use cases
- **presentation/** → UI (pages, widgets, controllers)

---

## 📊 How It Works

1. The app generates simulated sensor data (temperature, humidity)
2. Data is displayed in real-time on the dashboard
3. Values are stored in a local SQLite database
4. AI logic checks for abnormal conditions
5. Alerts are triggered when thresholds are exceeded

---

## 📦 Installation

### Prerequisites
- Flutter SDK installed
- Android Studio / VS Code
- Emulator or physical device

### Steps

```bash
# Clone the repository
git clone https://github.com/your-username/iot-monitor.git

# Navigate to project folder
cd iot-monitor

# Install dependencies
flutter pub get

# Run the app
flutter run