import 'dart:math';
import 'package:iot_mobile_app/features/sensor/data/sensor_repository_impl.dart';

class AIService {
  final SensorRepositoryImpl sensorRepository;

  AIService(this.sensorRepository);

  /// Prédit la température future basée sur une régression linéaire simple
  /// Utilise les dernières 10 lectures pour calculer la tendance
  Future<double> predictNextTemperature() async {
    final history = await sensorRepository.getAllData();
    if (history.length < 2) return 25.0; // Valeur par défaut si pas assez de données

    // Prendre les 10 dernières lectures
    final recentData = history.take(10).toList();
    final n = recentData.length;

    // Calculer la régression linéaire : y = mx + b
    // x = index (0 à n-1), y = température
    double sumX = 0, sumY = 0, sumXY = 0, sumXX = 0;

    for (int i = 0; i < n; i++) {
      final x = i.toDouble();
      final y = recentData[i].temperature;
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumXX += x * x;
    }

    final m = (n * sumXY - sumX * sumY) / (n * sumXX - sumX * sumX);
    final b = (sumY - m * sumX) / n;

    // Prédire pour x = n (prochaine valeur)
    final predictedTemp = m * n + b;

    // Limiter à des valeurs réalistes
    return max(0, min(50, predictedTemp));
  }

  /// Détecte des anomalies dans les données récentes
  /// Retourne true si la dernière température est anormale (déviation > 2 écarts-types)
  Future<bool> detectAnomaly() async {
    final history = await sensorRepository.getAllData();
    if (history.length < 5) return false;

    final recentData = history.take(10).toList();
    final temperatures = recentData.map((e) => e.temperature).toList();

    final mean = temperatures.reduce((a, b) => a + b) / temperatures.length;
    final variance = temperatures.map((t) => pow(t - mean, 2)).reduce((a, b) => a + b) / temperatures.length;
    final stdDev = sqrt(variance);

    final lastTemp = temperatures.last;
    final zScore = (lastTemp - mean) / stdDev;

    return zScore.abs() > 2.0; // Anomalie si déviation > 2 écarts-types
  }

  /// Calcule la tendance (hausse/baisse) basée sur les moyennes mobiles
  Future<String> getTrend() async {
    final history = await sensorRepository.getAllData();
    if (history.length < 10) return 'Stable';

    final recent = history.take(5).map((e) => e.temperature).toList();
    final older = history.skip(5).take(5).map((e) => e.temperature).toList();

    final recentAvg = recent.reduce((a, b) => a + b) / recent.length;
    final olderAvg = older.reduce((a, b) => a + b) / older.length;

    if (recentAvg > olderAvg + 1) return 'Hausse';
    if (recentAvg < olderAvg - 1) return 'Baisse';
    return 'Stable';
  }

  /// Recommande un ajustement du seuil basé sur l'historique
  Future<double> recommendThreshold() async {
    final history = await sensorRepository.getAllData();
    if (history.length < 5) return 30.0;

    final temperatures = history.map((e) => e.temperature).toList();
    final maxTemp = temperatures.reduce(max);
    final avgTemp = temperatures.reduce((a, b) => a + b) / temperatures.length;

    // Recommander un seuil légèrement au-dessus de la moyenne, mais en dessous du max
    return min(maxTemp - 2, avgTemp + 5);
  }
}