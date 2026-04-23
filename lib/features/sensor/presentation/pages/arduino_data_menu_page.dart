import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:iot_mobile_app/features/sensor/data/realtime_database_service.dart';

class ArduinoDataMenuPage extends StatefulWidget {
  const ArduinoDataMenuPage({super.key});

  @override
  State<ArduinoDataMenuPage> createState() => _ArduinoDataMenuPageState();
}

class _ArduinoDataMenuPageState extends State<ArduinoDataMenuPage> {
  late final RealtimeDatabaseService _databaseService;
  StreamSubscription<Map<String, dynamic>>? _arduinoSubscription;
  Map<String, dynamic> _arduinoData = {};
  DateTime? _lastUpdateTime;
  bool _isConnected = false;
  bool _isRefreshing = false;
  String _selectedDataView = 'all'; // 'all', 'temperature', 'humidity', 'sensors'

  @override
  void initState() {
    super.initState();
    _databaseService = RealtimeDatabaseService();
    _setupArduinoListener();
  }

  void _setupArduinoListener() {
    // Cancel previous subscription if any
    _arduinoSubscription?.cancel().catchError((_) {});

    // Set up new listener for Arduino data
    _arduinoSubscription = _databaseService.getArduinoDataStream().listen(
          (data) {
        if (mounted) {
          setState(() {
            _arduinoData = data;
            _lastUpdateTime = DateTime.now();
            _isConnected = true;
          });
        }
        print('Arduino data updated: $data');
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _isConnected = false;
          });
        }
        print('Stream error: $error');
        _showErrorSnackBar('Connection error: $error');
      },
      onDone: () {
        if (mounted) {
          setState(() {
            _isConnected = false;
          });
        }
        print('Stream closed, attempting reconnection...');
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) {
            _setupArduinoListener();
          }
        });
      },
    );
  }

  Future<void> _manualRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    try {
      // Fetch Arduino data directly
      final data = await _databaseService.getArduinoData();
      
      // Also fetch temperature directly as backup
      final temp = await _databaseService.getLatestTemperature();
      
      if (mounted) {
        setState(() {
          _arduinoData = data;
          if (temp != null && !_arduinoData.containsKey('temperature')) {
            _arduinoData['temperature'] = temp;
          }
          _lastUpdateTime = DateTime.now();
          _isConnected = true;
          _isRefreshing = false;
        });
      }
      _showSuccessSnackBar('Data refreshed successfully');
    } catch (e) {
      print('Manual refresh error: $e');
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
      _showErrorSnackBar('Refresh failed: $e');
    }
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return 'Never';
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat('HH:mm:ss').format(dateTime);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade700,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _arduinoSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arduino Data Monitor'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Tooltip(
                message: _isConnected ? 'Connected to Firebase' : 'Disconnected',
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isConnected ? Colors.green : Colors.red,
                    boxShadow: _isConnected
                        ? [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.6),
                              blurRadius: 6,
                              spreadRadius: 2,
                            )
                          ]
                        : [],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _manualRefresh,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade50,
                Colors.indigo.shade50,
              ],
            ),
          ),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Connection Status Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: _isConnected
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          _isConnected ? Icons.cloud_done : Icons.cloud_off,
                          color: _isConnected ? Colors.green : Colors.red,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isConnected ? 'Connected' : 'Disconnected',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: _isConnected
                                      ? Colors.green.shade700
                                      : Colors.red.shade700,
                                ),
                              ),
                              Text(
                                'Last update: ${_formatTime(_lastUpdateTime)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // View Selection Tabs
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildViewButton('All Data', 'all'),
                      _buildViewButton('Temperature', 'temperature'),
                      _buildViewButton('Humidity', 'humidity'),
                      _buildViewButton('Sensors', 'sensors'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Data Display
                if (_arduinoData.isEmpty)
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.sensors_off,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No Arduino Data Available',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.grey.shade700,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Make sure your Arduino is connected to Firebase\nand data is being uploaded to /arduino path',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  ..._buildDataWidgets(),

                const SizedBox(height: 20),

                // Raw JSON Display (for debugging)
                if (_arduinoData.isNotEmpty)
                  ExpansionTile(
                    title: const Text('Raw Data (JSON)'),
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            _formatJson(_arduinoData),
                            style: const TextStyle(
                              color: Colors.green,
                              fontFamily: 'Courier',
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 20),

                // Refresh Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isRefreshing ? null : _manualRefresh,
                    icon: _isRefreshing
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.refresh),
                    label: Text(_isRefreshing ? 'Refreshing...' : 'Refresh Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildViewButton(String label, String value) {
    final isSelected = _selectedDataView == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedDataView = value;
          });
        },
        backgroundColor: Colors.grey.shade200,
        selectedColor: Colors.blue.shade600,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade700,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  List<Widget> _buildDataWidgets() {
    final widgets = <Widget>[];

    if (_selectedDataView == 'all' || _selectedDataView == 'temperature') {
      final temp = _getTemperatureData();
      if (temp.isNotEmpty) {
        widgets.add(_buildDataCard('Temperature', temp, Colors.orange));
        widgets.add(const SizedBox(height: 16));
      }
    }

    if (_selectedDataView == 'all' || _selectedDataView == 'humidity') {
      final humidity = _getHumidityData();
      if (humidity.isNotEmpty) {
        widgets.add(_buildDataCard('Humidity', humidity, Colors.blue));
        widgets.add(const SizedBox(height: 16));
      }
    }

    if (_selectedDataView == 'all' || _selectedDataView == 'sensors') {
      final sensors = _getSensorData();
      if (sensors.isNotEmpty) {
        widgets.add(_buildDataCard('Sensor Status', sensors, Colors.green));
        widgets.add(const SizedBox(height: 16));
      }
    }

    if (widgets.isEmpty) {
      widgets.add(
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(
                'No $_selectedDataView data available',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  Widget _buildDataCard(
      String title, Map<String, dynamic> data, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.data_usage, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...data.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatLabel(entry.key),
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _formatValue(entry.value),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getTemperatureData() {
    final result = <String, dynamic>{};
    if (_arduinoData.containsKey('temperature')) {
      result['temperature'] = _arduinoData['temperature'];
    }
    if (_arduinoData.containsKey('temp')) {
      result['temp'] = _arduinoData['temp'];
    }
    if (_arduinoData.containsKey('current_temp')) {
      result['current_temp'] = _arduinoData['current_temp'];
    }
    return result;
  }

  Map<String, dynamic> _getHumidityData() {
    final result = <String, dynamic>{};
    if (_arduinoData.containsKey('humidity')) {
      result['humidity'] = _arduinoData['humidity'];
    }
    if (_arduinoData.containsKey('hum')) {
      result['hum'] = _arduinoData['hum'];
    }
    return result;
  }

  Map<String, dynamic> _getSensorData() {
    final result = <String, dynamic>{};
    if (_arduinoData.containsKey('sensor')) {
      result['sensor'] = _arduinoData['sensor'];
    }
    if (_arduinoData.containsKey('status')) {
      result['status'] = _arduinoData['status'];
    }
    return result;
  }

  String _formatLabel(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _formatValue(dynamic value) {
    if (value is double) {
      return value.toStringAsFixed(2);
    }
    return value.toString();
  }

  String _formatJson(Map<String, dynamic> data) {
    StringBuffer buffer = StringBuffer();
    data.forEach((key, value) {
      buffer.writeln('  "$key": $value');
    });
    return '{\n${buffer}}\n';
  }
}
