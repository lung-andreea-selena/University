import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/medical_record.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'medical_records.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await _createMedicalRecordsTable(db);
      },
    );
  }

  Future<void> _createMedicalRecordsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS medical_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        type TEXT,
        moneySpent REAL,
        date TEXT,
        details TEXT
      )
    ''');
  }

  Future<void> insertMedicalRecord(MedicalRecord record) async {
    final db = await database;
    await db.insert('medical_records', record.toMap());
  }

  Future<void> updateMedicalRecord(MedicalRecord record) async {
    final db = await database;
    await db.update(
      'medical_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<void> deleteMedicalRecord(int id) async {
    final db = await database;
    await db.delete(
      'medical_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<MedicalRecord>> getAllMedicalRecords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('medical_records');
    return List.generate(maps.length, (i) {
      return MedicalRecord.fromMap(maps[i]);
    });
  }
}
