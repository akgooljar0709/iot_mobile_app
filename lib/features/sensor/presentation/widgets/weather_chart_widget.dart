import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:iot_mobile_app/features/sensor/data/sensor_model.dart';

class WeatherChartWidget extends StatelessWidget {
  final List<SensorModel> sensorData;
  final String title;
  final String yAxisLabel;
  final Color lineColor;

  const WeatherChartWidget({
    super.key,
    required this.sensorData,
    required this.title,
    required this.yAxisLabel,
    this.lineColor = const Color(0xFF42A5F5),
  });

  @override
  Widget build(BuildContext context) {
    if (sensorData.isEmpty) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.show_chart, color: Colors.grey[400], size: 48),
              const SizedBox(height: 16),
              Text(
                'No data available',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: _getInterval(sensorData),
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey[300],
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey[300],
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: (sensorData.length / 6).ceilToDouble(),
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < sensorData.length) {
                            return Text(
                              index.toString(),
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: _getInterval(sensorData),
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 10),
                            textAlign: TextAlign.right,
                          );
                        },
                        reservedSize: 42,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      left: BorderSide(color: Colors.grey[300]!),
                      bottom: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  minX: 0,
                  maxX: (sensorData.length - 1).toDouble(),
                  minY: _getMinValue(sensorData),
                  maxY: _getMaxValue(sensorData),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _generateSpots(sensorData),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          lineColor.withOpacity(0.8),
                          lineColor.withOpacity(0.2),
                        ],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: sensorData.length <= 20,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: lineColor,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            lineColor.withOpacity(0.3),
                            lineColor.withOpacity(0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                  showingTooltipIndicators: [],
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateSpots(List<SensorModel> data) {
    return data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.temperature);
    }).toList();
  }

  double _getMinValue(List<SensorModel> data) {
    if (data.isEmpty) return 0;
    return data
        .map((e) => e.temperature)
        .reduce((a, b) => a < b ? a : b)
        .toDouble() -
        5;
  }

  double _getMaxValue(List<SensorModel> data) {
    if (data.isEmpty) return 100;
    return data
        .map((e) => e.temperature)
        .reduce((a, b) => a > b ? a : b)
        .toDouble() +
        5;
  }

  double _getInterval(List<SensorModel> data) {
    final min = _getMinValue(data);
    final max = _getMaxValue(data);
    final range = max - min;
    if (range <= 5) return 1;
    if (range <= 10) return 2;
    if (range <= 20) return 5;
    return 10;
  }
}
