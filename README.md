# 📱 Smart Home IoT Monitor

A hybrid mobile application developed using Flutter that simulates an IoT/AIoT environment.  
The app generates sensor data (temperature, humidity, etc.), stores it locally, and applies intelligent logic to detect abnormal conditions.

---

## 🚀 Features

### 🏠 Dashboard
- Displays real-time simulated sensor data
- Temperature, Humidity, and Status indicators
- Visual alerts (Green = Normal, Red = Critical)

### 💾 Data Storage
- Stores sensor readings locally using SQLite
- Keeps historical records of all data
- Allows users to view past sensor activity

### 🤖 AI / Smart Logic
- Detects abnormal conditions based on thresholds
- Example:
  - If temperature > 30°C → "Cooling system activated"
- Simulates intelligent IoT behavior

### ⚙️ Settings
- Modify threshold values
- Toggle between Light and Dark mode

---

## � API Configuration

This app uses the OpenWeatherMap API to fetch real weather data. To set it up:

### 1. Get an API Key
1. Visit [OpenWeatherMap](https://openweathermap.org/api)
2. Create a free account
3. Generate an API key from your dashboard

### 2. Configure Environment Variables
The app comes pre-configured with a demo API key. For production use:

1. Copy `.env.example` to `.env`
2. Add your own API key:
   ```
   OPENWEATHERMAP_API_KEY=your_actual_api_key_here
   ```

### 3. Run the App
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