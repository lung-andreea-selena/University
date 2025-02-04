import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/project.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final StreamController<Project> _projectStreamController = StreamController<Project>.broadcast();
  Stream<Project> get projectStream => _projectStreamController.stream;

  void connectWebSocket() {
    if (_channel != null) return; // Prevent multiple connections
    log('WebSocket connecting to: ws://192.168.1.132:2426');
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('ws://192.168.1.132:2426'),
      );

      _channel!.stream.listen((message) {
        log('WebSocket received: $message');
        try {
          final projectJson = jsonDecode(message);
          final project = Project.fromJson(projectJson);
          _projectStreamController.add(project);
        } catch (e) {
          log('WebSocket error decoding message: $e, message: $message');
        }
      }, onError: (error) {
        log('WebSocket error: $error');
        disconnectWebSocket();
      }, onDone: () {
        log('WebSocket disconnected');
        disconnectWebSocket();
      });
    } catch (e) {
      log('WebSocket connection error: $e');
      disconnectWebSocket();
    }
  }

  void disconnectWebSocket() {
    log('WebSocket disconnecting');
    _channel?.sink.close();
    _channel = null;
  }

  void dispose() {
    disconnectWebSocket();
    _projectStreamController.close();
  }
}
