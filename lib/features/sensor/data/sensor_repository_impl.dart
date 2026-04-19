import 'package:flutter/foundation.dart';
import 'sensor_local_db.dart';
import 'sensor_model.dart';

class SensorRepositoryImpl {
  final dbHelper = SensorLocalDB();
  static final List<SensorModel> _webStorage = [];

  Future<void> insertData(SensorModel data) async {
    if (kIsWeb) {
      _webStorage.insert(0, data);
      return;
    }

    final db = await dbHelper.database;
    await db.insert('sensor_data', data.toMap());
  }

  Future<List<SensorModel>> getAllData() async {
    if (kIsWeb) {
      return List.unmodifiable(_webStorage);
    }

    final db = await dbHelper.database;
    final result = await db.query('sensor_data', orderBy: 'id DESC');
    return result.map((e) => SensorModel.fromMap(e)).toList();
  }
}