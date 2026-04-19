# IoT Weather Monitor - User Guide

## 📱 Getting Started

### First Launch
1. App opens directly to the weather dashboard
2. Default city: Pamplemousses, Mauritius
3. Real-time weather data loads automatically
4. Sensor data begins logging to the database

## 🎨 Dashboard Overview

### Main Components

#### Weather Card (Top)
- **Large Weather Icon**: Visual representation of current conditions
- **City Name**: Location of the weather data
- **Weather Description**: e.g., "Partly Cloudy", "Light Rain"
- **Three Metrics**:
  - 🌡️ Temperature: Current temperature in Celsius
  - 💧 Humidity: Moisture percentage in the air
  - 💨 Wind Speed: Speed in meters per second

#### Status Indicator
- **Green Circle + "Normal"**: Temperature is below threshold
- **Red Alert + "High Temperature"**: Temperature exceeds 30°C threshold
- Shows helpful information about current conditions

#### Temperature Trend Chart
- Displays temperature history from stored sensor data
- Smooth line graph with easy-to-read axis labels
- Useful for tracking patterns and trends
- Updates automatically as new data arrives

#### Quick Stats Section
- **Average Temperature**: Calculated from all stored readings
- **Data Points**: Total number of records collected

## 🎯 How to Use

### Changing Cities

1. **Tap Location Icon** (📍) in the top right of the app bar
2. **Browse Cities**: See list of 15 popular cities:
   - Mauritius: Pamplemousses, Port Louis
   - USA: New York
   - UK: London
   - Japan: Tokyo
   - France: Paris
   - And more...
3. **Search**: Type city name or country to filter
4. **Select**: Tap any city to load its weather data
5. **Auto-Update**: Dashboard immediately shows new weather

### Refreshing Weather Data

**Three ways to refresh**:

1. **Pull Down**: Swipe down on the dashboard to refresh
2. **Refresh Icon**: Tap the refresh icon (🔄) in the top right
3. **Automatic**: Weather updates every 30 seconds

### Viewing History

1. **Tap History Icon** (📜) in the top right
2. See all previously recorded sensor readings
3. Timestamps show when data was recorded
4. Scroll to see more records

## 🌤️ Weather Icons

The app displays different icons based on weather conditions:

| Weather | Icon | Notes |
|---------|------|-------|
| Sunny | ☀️ | Clear skies, orange color |
| Cloudy | ☁️ | Overcast, light blue color |
| Rainy | 🌧️ | Precipitation, deeper blue |
| Stormy | ⚡ | Thunder/lightning, orange/red |
| Snowy | ❄️ | Winter weather, light blue |
| Foggy | 🌫️ | Reduced visibility, gray |

## 📊 Understanding the Chart

### Chart Components
- **X-Axis**: Data point index (0-20 recent readings)
- **Y-Axis**: Temperature in Celsius
- **Line**: Temperature trend over time
- **Colored Area**: Gradient fill showing temperature range
- **Dots**: Individual data points (hidden if >20 readings)

### Interpreting Trends
- **Rising Line**: Temperature increasing
- **Declining Line**: Temperature decreasing
- **Flat Line**: Temperature stable
- **Steep Changes**: Rapid temperature fluctuations

## ⚠️ Alert System

### Temperature Threshold
- **Default Threshold**: 30°C
- **When Exceeded**:
  - Status changes to "High Temperature"
  - Card background changes to red
  - Alert icon displays

### What It Means
- Most comfortable range: 20-25°C
- Warm but acceptable: 25-30°C
- High/warm: 30°C and above
- Adjustment available in future versions

## 🔋 Data Storage

### What Gets Saved
- Temperature readings
- Humidity levels
- Timestamps of measurements
- Up to 20 readings displayed in charts

### Data Persistence
- All data stored locally on device
- Survives app restarts
- No data sent to external servers (except OpenWeatherMap API)
- Automatic cleanup of old data (optional in settings)

## 🌐 Network & API

### Online Requirements
- Real-time weather requires internet connection
- API calls to OpenWeatherMap service
- ~1 second per request typically

### Offline Mode
- App continues if network drops
- Uses cached weather data
- Sensor data continues logging
- API calls resume when network returns

### API Status
- Free tier: 1000 calls/day
- Current usage monitored
- Rate limiting: 60 calls/minute typically

## ⚙️ Settings & Preferences

### Current Features
- Temperature unit: Celsius (can be extended)
- Update interval: Every 30 seconds
- Chart display: Last 20 readings

### Future Settings
- Temperature threshold customization
- Notification preferences
- Background refresh
- Data export options

## 🐛 Troubleshooting

### Weather Data Not Loading
1. Check internet connection
2. Tap refresh button
3. Verify API key is valid
4. Try selecting a different city

### City Not Found
1. Check exact spelling
2. Try alternate city name
3. Use a different location
4. City name is case-insensitive

### Chart Not Showing
1. Need at least 1 data point
2. Wait 30 seconds for first reading
3. Try other city to generate data
4. Check app isn't minimized

### Slow Performance
1. Clear app cache (Settings > Apps > App Info > Storage > Clear Cache)
2. Restart app and device
3. Check network connection quality
4. Update to latest app version

## 📞 Support Resources

### Common Issues

**"API key not configured"**
- App is missing API key
- Contact app developer
- Not a user error

**"City not found: [city name]"**
- City name not recognized
- Try different spelling
- Select from popular cities list

**"Network error: Connection timeout"**
- Internet connection issue
- Try again in a moment
- App will retry automatically

**"Failed to load weather data"**
- API issue or rate limit
- App will retry automatically
- Try again after 1 minute

## 🔒 Privacy & Data

### Data Collected
- Local: Temperature and humidity readings
- Remote: OpenWeatherMap API queries
- No personal information required

### Data Shared
- Only weather data sent to OpenWeatherMap
- API queries are necessary to fetch weather
- No data shared with advertisers
- No analytics tracking (in basic version)

## 💡 Tips & Tricks

1. **Quick City Switch**: Tap location icon for fastest city change
2. **Chart Patterns**: Watch for daily temperature cycles
3. **Humidity Tracking**: High humidity = sticky weather
4. **Wind Planning**: Plan outdoor activities based on wind speed
5. **History Reference**: Use sensor history for long-term patterns

## 🎯 Best Practices

- **Refresh Regularly**: Get latest weather every few minutes
- **Monitor Trends**: Use charts to understand local patterns
- **Set Expectations**: Understand weather conditions before planning
- **Keep Updated**: Update app for latest features and fixes
- **Check Network**: Ensure stable internet for accurate data

---

**Version**: 1.0.0  
**Last Updated**: April 15, 2026  
**For Support**: Check PLAYSTORE_DEPLOYMENT.md for contact information
