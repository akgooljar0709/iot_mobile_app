import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:iot_mobile_app/features/sensor/data/realtime_database_service.dart';

class RealtimeArduinoPage extends StatefulWidget {
  const RealtimeArduinoPage({super.key});

  @override
  State<RealtimeArduinoPage> createState() => _RealtimeArduinoPageState();
}

class _RealtimeArduinoPageState extends State<RealtimeArduinoPage> {
  late final RealtimeDatabaseService _databaseService;
  StreamSubscription<double?>? _temperatureSubscription;
  double? _currentTemperature;
  DateTime? _lastUpdateTime;
  bool _isConnected = false;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _databaseService = RealtimeDatabaseService();
    _setupTemperatureListener();
  }

  void _setupTemperatureListener() {
    // Cancel previous subscription if any
    _temperatureSubscription?.cancel().catchError((_) {});

    // Set up new listener
    _temperatureSubscription =
        _databaseService.getTemperatureStream().listen(
              (temperature) {
            if (mounted) {
              setState(() {
                _currentTemperature = temperature;
                _lastUpdateTime = DateTime.now();
                _isConnected = true;
              });
            }
            print('Temperature updated: $temperature at $_lastUpdateTime');
          },
          onError: (error) {
            if (mounted) {
              setState(() {
                _isConnected = false;
              });
            }
            print('Stream error: $error');
          },
          onDone: () {
            if (mounted) {
              setState(() {
                _isConnected = false;
              });
            }
            print('Stream closed');
            // Automatically try to reconnect after 5 seconds
            Future.delayed(const Duration(seconds: 5), () {
              if (mounted) {
                _setupTemperatureListener();
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
      // Re-establish the listener to ensure fresh connection
      _setupTemperatureListener();
      
      // Also try to fetch the latest value directly
      final latest = await _databaseService.getLatestTemperature();
      if (mounted) {
        setState(() {
          if (latest != null) {
            _currentTemperature = latest;
            _lastUpdateTime = DateTime.now();
            _isConnected = true;
          }
          _isRefreshing = false;
        });
      }
    } catch (e) {
      print('Manual refresh error: $e');
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
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

  @override
  void dispose() {
    _temperatureSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Arduino Monitor'),
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
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.orange.shade50,
                Colors.amber.shade50,
              ],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Temperature Card
                  Card(
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.orange.shade400,
                            Colors.amber.shade600,
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(48),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.thermostat,
                            size: 100,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'Current Temperature',
                            style:
                                Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          const SizedBox(height: 16),
                          if (_currentTemperature != null)
                            Text(
                              '${_currentTemperature!.toStringAsFixed(2)}°C',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 72,
                                  ),
                            )
                          else
                            SizedBox(
                              height: 80,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Loading...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Status and Update Information
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue.shade600,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Status Information',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildStatusRow(
                          'Connection',
                          _isConnected ? 'Connected' : 'Disconnected',
                          _isConnected ? Colors.green : Colors.red,
                        ),
                        const SizedBox(height: 8),
                        _buildStatusRow(
                          'Last Update',
                          _formatTime(_lastUpdateTime),
                          Colors.blue,
                        ),
                        if (_lastUpdateTime != null) ...[
                          const SizedBox(height: 8),
                          _buildStatusRow(
                            'Timestamp',
                            DateFormat('HH:mm:ss').format(_lastUpdateTime!),
                            Colors.purple,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Refresh Button
                  ElevatedButton.icon(
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
                      backgroundColor: Colors.orange.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
