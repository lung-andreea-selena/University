import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/recipe.dart';

// WebSocket Service
class WebSocketService {
  WebSocketChannel? _channel; //holds the websocket connection
  final StreamController<Recipe> _recipeStreamController = StreamController<Recipe>.broadcast(); //a streamcontroller for broadcasting real time recipe updates
  Stream<Recipe> get recipeStream => _recipeStreamController.stream; //provides a public stream for UI components to listen for real time updates

  void connectWebSocket() {
    if (_channel != null) return; // Prevent multiple connections
    log('WebSocket connecting to: ws://192.168.1.132:2528');
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('ws://192.168.1.132:2528'),// change this (cmd-> ipconfig wirless lan..-> ipv4)
      );

      _channel!.stream.listen((message) {
        log('WebSocket received: $message');
        try {
          final recipeJson = jsonDecode(message);
          final recipe = Recipe.fromJson(recipeJson);
          _recipeStreamController.add(recipe); //adds the recipe to the stream so UI can react to it
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

  void dispose() { //cleans up resources and closes the stream
    disconnectWebSocket();
    _recipeStreamController.close();
  }
}