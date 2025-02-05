import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../services/websocket_service.dart';

class WebSocketProvider extends ChangeNotifier {
  final WebSocketService _webSocketService = WebSocketService();
  Workout? _newWorkoutNotification;

  Workout? get newWorkoutNotification => _newWorkoutNotification;

  WebSocketProvider() {
    _webSocketService.connectWebSocket();
    _webSocketService.workoutStream.listen((workout) {
      _newWorkoutNotification = workout;
      notifyListeners();

      //reset notification
      Future.delayed(const Duration(milliseconds: 500), () {
        _newWorkoutNotification = null;
        notifyListeners();
      });
    });
  }

  @override
  void dispose() {
    _webSocketService.dispose();
    super.dispose();
  }
}
