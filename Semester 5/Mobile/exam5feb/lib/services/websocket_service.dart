import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/workout.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final StreamController<Workout> _workoutStreamController = StreamController<Workout>.broadcast();
  Stream<Workout> get workoutStream => _workoutStreamController.stream;

  void connectWebSocket() {
    if (_channel != null) return; //prevent multiple connections
    log('WebSocket connecting to: ws://172.30.252.67:2505');
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('ws://172.30.252.67:2505'),
      );

      _channel!.stream.listen((message) {
        log('WebSocket received: $message');
        try {
          final workoutJson = jsonDecode(message);
          final workout = Workout.fromJson(workoutJson);
          _workoutStreamController.add(workout);
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
    _workoutStreamController.close();
  }
}