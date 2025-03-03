import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/medical_record.dart';

class MedicalRecordRepository with ChangeNotifier {
  final DBHelper _dbHelper = DBHelper();
  List<MedicalRecord> _records = [];

  List<MedicalRecord> get records => _records;

  MedicalRecordRepository() {
    loadRecords();
  }

  Future<void> loadRecords() async {
    try {
      final dbRecords = await _dbHelper.database.then((db) => db.query('medical_records'));
      _records = dbRecords.map((map) => MedicalRecord.fromMap(map)).toList();
      debugPrint('Medical records loaded successfully: $_records');
      notifyListeners();
    } catch (error) {
      debugPrint('Error loading medical records: $error');
    }
  }

  Future<void> addRecord(MedicalRecord record) async {
    try {
      final db = await _dbHelper.database;
      final id = await db.insert('medical_records', record.toMap());
      final newRecord = MedicalRecord(
        id: id,
        title: record.title,
        type: record.type,
        date: record.date,
        details: record.details,
        moneySpent: record.moneySpent,
      );
      _records.add(newRecord);
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to add record: $e');
      throw Exception('Failed to add record');
    }
  }

  Future<void> updateRecord(MedicalRecord updatedRecord) async {
    try {
      await _dbHelper.updateMedicalRecord(updatedRecord);
      final index = _records.indexWhere((record) => record.id == updatedRecord.id);
      if (index != -1) {
        _records[index] = updatedRecord;
        notifyListeners();
      }
    } catch (error) {
      debugPrint('Error updating medical record: $error');
      rethrow;
    }
  }

  Future<void> deleteRecord(int recordId) async {
    try {
      await _dbHelper.deleteMedicalRecord(recordId);
      _records.removeWhere((record) => record.id == recordId);
      notifyListeners();
    } catch (error) {
      debugPrint('Error deleting medical record: $error');
      rethrow;
    }
  }
}
