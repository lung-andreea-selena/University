import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; // For Stream and WebSocket
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/medical_record.dart';

class MedicalRecordRepository with ChangeNotifier {
  static const String _baseUrl = 'http://10.0.2.2:3000/records';
  static const String _wsUrl = 'ws://10.0.2.2:3000/';
  final WebSocketChannel _channel = WebSocketChannel.connect(Uri.parse(_wsUrl));

  List<MedicalRecord> _records = [];

  List<MedicalRecord> get records => _records;

  MedicalRecordRepository() {
    fetchRecords();
    _listenToWebSocket();
  }

  Future<void> fetchRecords() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> recordsJson = jsonDecode(response.body);
        _records = recordsJson.map((json) => MedicalRecord.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load records');
      }
    } catch (e) {
      debugPrint('Error fetching records: $e');
      rethrow;
    }
  }

  Future<void> addRecord(MedicalRecord record) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(record.toJson()),
      );
      if (response.statusCode == 201) {
        MedicalRecord newRecord = MedicalRecord.fromJson(jsonDecode(response.body));
        _records.add(newRecord);
        notifyListeners();
      } else {
        throw Exception('Failed to add record');
      }
    } catch (e) {
      debugPrint('Failed to add record: $e');
      throw Exception('Failed to add record');
    }
  }

  Future<void> updateRecord(MedicalRecord updatedRecord) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/${updatedRecord.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedRecord.toJson()),
      );
      if (response.statusCode == 200) {
        final index = _records.indexWhere((record) => record.id == updatedRecord.id);
        if (index != -1) {
          _records[index] = updatedRecord;
          notifyListeners();
        }
      } else {
        throw Exception('Failed to update record');
      }
    } catch (e) {
      debugPrint('Error updating record: $e');
      rethrow;
    }
  }

  Future<void> deleteRecord(int recordId) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/$recordId'));
      if (response.statusCode == 200) {
        _records.removeWhere((record) => record.id == recordId);
        notifyListeners();
      } else {
        throw Exception('Failed to delete record');
      }
    } catch (e) {
      debugPrint('Error deleting record: $e');
      rethrow;
    }
  }

  void _listenToWebSocket() {
    _channel.stream.listen((message) {
      var decodedMessage = jsonDecode(message);
      switch (decodedMessage['action']) {
        case 'create':
          _handleRecordCreated(decodedMessage['record']);
          break;
        case 'update':
          _handleRecordUpdated(decodedMessage['record']);
          break;
        case 'delete':
          _handleRecordDeleted(decodedMessage['id']);
          break;
      }
    }, onDone: () {
      debugPrint('WebSocket connection closed');
    }, onError: (error) {
      debugPrint('WebSocket error: $error');
    });
  }

  void _handleRecordCreated(Map<String, dynamic> recordJson) {
    MedicalRecord newRecord = MedicalRecord.fromJson(recordJson);
    _records.add(newRecord);
    notifyListeners();
  }

  void _handleRecordUpdated(Map<String, dynamic> recordJson) {
    int index = _records.indexWhere((record) => record.id == recordJson['id']);
    if (index != -1) {
      _records[index] = MedicalRecord.fromJson(recordJson);
      notifyListeners();
    }
  }

  void _handleRecordDeleted(int id) {
    _records.removeWhere((record) => record.id == id);
    notifyListeners();
  }
}
