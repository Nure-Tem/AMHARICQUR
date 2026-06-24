import 'package:sqflite/sqflite.dart';

import '../../../../core/constants/database_tables.dart';
import '../../../../domain/entities/app_settings.dart';
import '../../../models/app_settings_model.dart';
import '../database/app_database.dart';

abstract class SettingsDao {
  Future<AppSettings> getSettings();
  Future<void> saveSettings(AppSettings settings);
  Future<String?> getValue(String key);
  Future<void> setValue(String key, String value);
}

class SettingsDaoImpl implements SettingsDao {
  SettingsDaoImpl(this._database);

  final AppDatabase _database;

  @override
  Future<AppSettings> getSettings() async {
    final rows = await _database.db.query(DatabaseTables.settings);
    if (rows.isEmpty) return const AppSettings();
    final models = rows.map((r) => SettingModel.fromMap(r)).toList();
    return AppSettingsModel.fromRows(models);
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final rows = AppSettingsModel.toRows(settings, now);
    final batch = _database.db.batch();
    for (final row in rows) {
      batch.insert(
        DatabaseTables.settings,
        row.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<String?> getValue(String key) async {
    final rows = await _database.db.query(
      DatabaseTables.settings,
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['value'] as String?;
  }

  @override
  Future<void> setValue(String key, String value) async {
    await _database.db.insert(
      DatabaseTables.settings,
      SettingModel(
        key: key,
        value: value,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
