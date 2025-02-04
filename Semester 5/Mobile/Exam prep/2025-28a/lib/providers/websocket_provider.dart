import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../services/websocket_service.dart';

class WebSocketProvider extends ChangeNotifier {
  final WebSocketService _webSocketService = WebSocketService();
  Recipe? _newRecipeNotification; //holds the latest recipe received

  Recipe? get newRecipeNotification => _newRecipeNotification;//getter, allows ui components to access the latest notification

  WebSocketProvider() {
    _webSocketService.connectWebSocket();
    _webSocketService.recipeStream.listen((recipe) {
      _newRecipeNotification = recipe; //Listens to recipeStream, updating _newRecipeNotification whenever a new recipe is received
      notifyListeners(); //triggers UI updates
      // Reset notification after consumption
      Future.delayed(const Duration(milliseconds: 500), () {
        _newRecipeNotification = null;
        notifyListeners();
      });
    });
  }

  @override
  void dispose() { // ensures ws disconnects when the provider is destroyed
    _webSocketService.dispose();
    super.dispose();
  }
}