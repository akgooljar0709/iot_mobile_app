import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:iot_mobile_app/features/sensor/data/realtime_database_service.dart';

class RealtimeArduinoGraphPage extends StatefulWidget {
  const RealtimeArduinoGraphPage({super.key});

  @override
  State<RealtimeArduinoGraphPage> createState() =>
      _RealtimeArduinoGraphPageState();
}

class _RealtimeArduinoGraphPageState extends State<RealtimeArduinoGraphPage> {
  late final RealtimeDatabaseService _databaseService;
  StreamSubscription<double?>? _temperatureSubscription;
  StreamSubscription<Map<String, dynamic>>? _arduinoSubscription;

  // Temperature data points for graph
  final List<TemperaturePoint> _temperatureHistory = [];
  double? _currentTemperature;
  Map<String, dynamic> _arduinoData = {};
  DateTime? _lastUpdateTime;
  bool _isConnected = false;
  bool _isRefreshing = false;
  double _minTemp = 0;
  double _maxTemp = 50;

  // Settings
  int _maxDataPoints = 60; // Keep last 60 readings
  bool _showTemperature = true;
  bool _showHumidity = false;

  @override
  void initState() {
    super.initState();
    _databaseService = RealtimeDatabaseService();
    _setupListeners();
  }

  void _setupListeners() {
    // Cancel previous subscriptions
    _temperatureSubscription?.cancel().catchError((_) {});
    _arduinoSubscription?.cancel().catchError((_) {});

    // Listen to temperature stream
    _temperatureSubscription =
        _databaseService.getTemperatureStream().listen(
              (temperature) {
        if (mounted && temperature != null) {
          setState(() {
            _currentTemperature = temperature;
            _lastUpdateTime = DateTime.now();
            _isConnected = true;

            // Add to history
            _temperatureHistory.add(
              TemperaturePoint(
                value: temperature,
                timestamp: DateTime.now(),
              ),
            );

            // Keep only last N points
            if (_temperatureHistory.length > _maxDataPoints) {
              _temperatureHistory.removeAt(0);
            }

            // Update min/max
            if (temperature < _minTemp) _minTemp = temperature;
            if (temperature > _maxTemp) _maxTemp = temperature;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _isConnected = false;
          });
        }
        print('Temperature stream error: $error');
      },
      onDone: () {
        if (mounted) {
          setState(() {
            _isConnected = false;
          });
        }
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) {
            _setupListeners();
          }
        });
      },
    );

    // Listen to Arduino data stream
    _arduinoSubscription =
        _databaseService.getArduinoDataStream().listen(
              (data) {
        if (mounted) {
          setState(() {
            _arduinoData = data;
          });
        }
      },
      onError: (error) {
        print('Arduino data stream error: $error');
      },
    );
  }

  Future<void> _manualRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    try {
      final temp = await _databaseService.getLatestTemperature();
      final data = await _databaseService.getArduinoData();

      if (mounted) {
        setState(() {
          if (temp != null) {
            _currentTemperature = temp;
            _lastUpdateTime = DateTime.now();
            _isConnected = true;

            _temperatureHistory.add(
              TemperaturePoint(
                value: temp,
                timestamp: DateTime.now(),
              ),
            );

            if (_temperatureHistory.length > _maxDataPoints) {
              _temperatureHistory.removeAt(0);
            }

            if (temp < _minTemp) _minTemp = temp;
            if (temp > _maxTemp) _maxTemp = temp;
          }
          _arduinoData = data;
          _isRefreshing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
      print('Manual refresh error: $e');
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
    } else {
      return DateFormat('HH:mm:ss').format(dateTime);
    }
  }

  @override
  void dispose() {
    _temperatureSubscription?.cancel();
    _arduinoSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Arduino Graph'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Tooltip(
                message: _isConnected ? 'Connected' : 'Disconnected',
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
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current Temperature Display
                  _buildCurrentTempCard(),
                  const SizedBox(height: 20),

                  // Real-Time Graph
                  _buildGraphCard(),
                  const SizedBox(height: 20),

                  // Stats
                  _buildStatsCard(),
                  const SizedBox(height: 20),

                  // Data Points List
                  _buildDataPointsList(),
                  const SizedBox(height: 20),

                  // Arduino Data
                  if (_arduinoData.isNotEmpty) _buildArduinoDataCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentTempCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.orange.shade400,
              Colors.amber.shade600,
            ],
          ),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.thermostat,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              'Current Temperature',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 8),
            if (_currentTemperature != null)
              Text(
                '${_currentTemperature!.toStringAsFixed(2)}°C',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              )
            else
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Updated: ${_formatTime(_lastUpdateTime)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraphCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Temperature Graph',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_temperatureHistory.length} points',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_temperatureHistory.isEmpty)
              Container(
                height: 200,
                alignment: Alignment.center,
                child: Text(
                  'Waiting for temperature data...',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                ),
              )
            else
              CustomPaint(
                painter: TemperatureGraphPainter(
                  dataPoints: _temperatureHistory,
                  minValue: _minTemp,
                  maxValue: _maxTemp,
                ),
                size: const Size(double.infinity, 250),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    double avgTemp = 0;
    if (_temperatureHistory.isNotEmpty) {
      avgTemp = _temperatureHistory
              .map((p) => p.value)
              .reduce((a, b) => a + b) /
          _temperatureHistory.length;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem(
              'Min',
              '${_minTemp.toStringAsFixed(1)}°C',
              Colors.blue,
            ),
            _buildStatItem(
              'Avg',
              '${avgTemp.toStringAsFixed(1)}°C',
              Colors.green,
            ),
            _buildStatItem(
              'Max',
              '${_maxTemp.toStringAsFixed(1)}°C',
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDataPointsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Readings',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 300),
            child: _temperatureHistory.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'No data yet',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: _temperatureHistory.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: Colors.grey.shade200),
                    itemBuilder: (context, index) {
                      final point = _temperatureHistory[index];
                      return Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Reading ${index + 1}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  DateFormat('HH:mm:ss')
                                      .format(point.timestamp),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${point.value.toStringAsFixed(2)}°C',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildArduinoDataCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Arduino Raw Data',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ..._arduinoData.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      entry.value.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
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
}

class TemperaturePoint {
  final double value;
  final DateTime timestamp;

  TemperaturePoint({
    required this.value,
    required this.timestamp,
  });
}

class TemperatureGraphPainter extends CustomPainter {
  final List<TemperaturePoint> dataPoints;
  final double minValue;
  final double maxValue;

  TemperatureGraphPainter({
    required this.dataPoints,
    required this.minValue,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final paint = Paint()
      ..color = Colors.orange.shade600
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final pointPaint = Paint()
      ..color = Colors.orange.shade600
      ..strokeWidth = 0;

    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 0.5;

    // Draw grid
    const gridLines = 5;
    for (int i = 0; i <= gridLines; i++) {
      final y = (size.height / gridLines) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Calculate scale
    final range = maxValue - minValue;
    final step = size.width / (dataPoints.length - 1);

    // Draw line
    for (int i = 0; i < dataPoints.length - 1; i++) {
      final current = dataPoints[i];
      final next = dataPoints[i + 1];

      final x1 = i * step;
      final y1 = size.height -
          ((current.value - minValue) / range) * size.height;
      final x2 = (i + 1) * step;
      final y2 = size.height - ((next.value - minValue) / range) * size.height;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }

    // Draw points
    for (int i = 0; i < dataPoints.length; i++) {
      final x = i * step;
      final y = size.height -
          ((dataPoints[i].value - minValue) / range) * size.height;
      canvas.drawCircle(Offset(x, y), 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(TemperatureGraphPainter oldDelegate) => true;
}
