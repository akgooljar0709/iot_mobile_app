class SensorModel {
  final int? id;
  final double temperature;
  final double humidity;
  final String timestamp;

  SensorModel({
    this.id,
    required this.temperature,
    required this.humidity,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'temperature': temperature,
      'humidity': humidity,
      'timestamp': timestamp,
    };
  }

  factory SensorModel.fromMap(Map<String, dynamic> map) {
    return SensorModel(
      id: map['id'],
      temperature: map['temperature'],
      humidity: map['humidity'],
      timestamp: map['timestamp'],
    );
  }
}