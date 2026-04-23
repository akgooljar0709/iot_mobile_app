import 'package:firebase_database/firebase_database.dart';

class RealtimeDatabaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  // Get latest temperature sensor reading
  Future<double?> getLatestTemperature() async {
    try {
      final snapshot = await _db.child('temperature').get().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('Temperature fetch timeout - no response from Firebase');
          throw Exception('Firebase connection timeout');
        },
      );
      print('Temperature snapshot exists: ${snapshot.exists}');
      print('Temperature snapshot value: ${snapshot.value}');
      if (snapshot.exists) {
        final temp = double.tryParse(snapshot.value.toString());
        print('Parsed temperature: $temp');
        return temp;
      }
      print('No temperature data found in Firebase');
      return null;
    } catch (e) {
      print('Error getting temperature: $e');
      return null;
    }
  }

  // Listen to real-time temperature changes
  Stream<double?> getTemperatureStream() {
    return _db.child('temperature').onValue.map((event) {
      try {
        if (event.snapshot.exists) {
          return double.tryParse(event.snapshot.value.toString());
        }
        return null;
      } catch (e) {
        print('Error parsing temperature: $e');
        return null;
      }
    });
  }

  // Get sensor status
  Future<Map<String, dynamic>> getSensorStatus() async {
    try {
      final snapshot = await _db.child('sensor').get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return {};
    } catch (e) {
      print('Error getting sensor status: $e');
      return {};
    }
  }

  // Listen to sensor status changes
  Stream<Map<String, dynamic>> getSensorStatusStream() {
    return _db.child('sensor').onValue.map((event) {
      try {
        if (event.snapshot.exists) {
          return Map<String, dynamic>.from(event.snapshot.value as Map);
        }
        return {};
      } catch (e) {
        print('Error parsing sensor status: $e');
        return {};
      }
    });
  }

  // Get all Arduino sensor data
  Future<Map<String, dynamic>> getArduinoData() async {
    try {
      final snapshot = await _db.child('arduino').get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return {};
    } catch (e) {
      print('Error getting Arduino data: $e');
      return {};
    }
  }

  // Listen to Arduino data in real-time
  Stream<Map<String, dynamic>> getArduinoDataStream() {
    return _db.child('arduino').onValue.map((event) {
      try {
        if (event.snapshot.exists) {
          return Map<String, dynamic>.from(event.snapshot.value as Map);
        }
        return {};
      } catch (e) {
        print('Error parsing Arduino data: $e');
        return {};
      }
    });
  }
}
