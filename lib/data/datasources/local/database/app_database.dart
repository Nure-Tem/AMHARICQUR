import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart' as errors;
import 'database_schema.dart';

/// Opens and initializes the SQLite database.
///
/// On first launch, copies the bundled book database asset and ensures
/// user-data tables exist.
class AppDatabase {
  AppDatabase._();

  static AppDatabase? _instance;
  static Database? _database;

  static Future<AppDatabase> getInstance() async {
    _instance ??= AppDatabase._();
    _database ??= await _instance!._openDatabase();
    return _instance!;
  }

  Database get db {
    final database = _database;
    if (database == null) {
      throw const errors.DatabaseException(
        'Database not initialized. Call getInstance() first.',
      );
    }
    return database;
  }

  Future<Database> _openDatabase() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(documentsDir.path, AppConstants.databaseName);
    final dbFile = File(dbPath);

    if (!await dbFile.exists()) {
      await _copyBundledDatabase(dbPath);
    }

    final database = await openDatabase(
      dbPath,
      version: DatabaseSchema.version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    await _ensureUserTables(database);
    return database;
  }

  Future<void> _copyBundledDatabase(String targetPath) async {
    try {
      final data = await rootBundle.load(AppConstants.bundledDatabaseAsset);
      final file = File(targetPath);
      await file.create(recursive: true);
      await file.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        flush: true,
      );
    } on FlutterError {
      // Bundled asset not yet present — create empty DB with full schema.
      // Content will be imported in a later implementation phase.
      final database = await openDatabase(
        targetPath,
        version: DatabaseSchema.version,
        onCreate: _onCreate,
      );
      await database.close();
    } catch (e) {
      throw errors.BookAssetException(
        'Failed to copy bundled database',
        cause: e,
      );
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();
    for (final sql in DatabaseSchema.createBookContentTables) {
      batch.execute(sql);
    }
    for (final sql in DatabaseSchema.createUserTables) {
      batch.execute(sql);
    }
    await batch.commit(noResult: true);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Migration scripts will be added per version in implementation phase.
  }

  Future<void> _ensureUserTables(Database db) async {
    final batch = db.batch();
    for (final sql in DatabaseSchema.createUserTables) {
      batch.execute(sql);
    }
    await batch.commit(noResult: true);
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
    _instance = null;
  }
}
