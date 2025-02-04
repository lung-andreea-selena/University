import 'package:flutter/material.dart';
import '../models/project.dart';
import '../services/websocket_service.dart';

class WebSocketProvider extends ChangeNotifier {
  final WebSocketService _webSocketService = WebSocketService();
  Project? _newProjectNotification;

  Project? get newProjectNotification => _newProjectNotification;

  WebSocketProvider() {
    _webSocketService.connectWebSocket();
    _webSocketService.projectStream.listen((project) {
      _newProjectNotification = project;
      notifyListeners();
      // Reset notification after consumption
      Future.delayed(const Duration(milliseconds: 500), () {
        _newProjectNotification = null;
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
