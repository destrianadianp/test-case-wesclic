import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:test_case_skill/core/database/database_helper.dart';
import 'package:test_case_skill/core/models/chat_model.dart';
import 'package:test_case_skill/modules/socket_manager/socket_manager.dart';

class SocketViewmodel extends ChangeNotifier {
  final SocketManager _mgr = SocketManager.shared;
  final DatabaseHelper _db = DatabaseHelper();
  List<ChatModel> _messages = [];
  String? _myName;
  bool _isSocketInitialized = false;

  String? get myName => _myName;
  // Return a copy to prevent external modification
  List<ChatModel> get messages => List.from(_messages);

  SocketViewmodel() {
    _init();
  }

  Future<void> _init() async {
    await fetchHistory();
  }

  Future<void> fetchHistory() async {
    try {
      final data = await _db.getAllMessages();
      final newMessages = data.map((e) => ChatModel.fromMap(e)).toList();

      // Update messages list and notify listeners
      _messages = newMessages;
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching history: $e');
    }
  }

  void initSocket(String myName) {
    if (_isSocketInitialized) {
      _myName = myName;
      return;
    }

    _myName = myName;
    _mgr.connect();

    _mgr.stream?.listen((event) async {
      try {
        final decoded = jsonDecode(event);

        // Check if this is a message from the current user to avoid duplication
        if (decoded['sender'] != _myName) {
          // Add the received message to our local list directly
          final newMessage = ChatModel(
            sender: decoded['sender'],
            message: decoded['message'],
            time: decoded['time'] ?? DateTime.now().toString(),
          );

          _messages.add(newMessage);
          // Use a post-frame callback to ensure UI updates properly
          notifyListeners();

          // Store in database
          await _db.insertMessage({
            'sender': decoded['sender'],
            'message': decoded['message'],
            'time': decoded['time'] ?? DateTime.now().toString(),
          });
        }
      } catch (e) {
        debugPrint('Error processing received message: $e');
      }
    });

    _isSocketInitialized = true;
  }

  void clearMyName() {
    _myName = null;
  }

  void sendMessage(String text, String myName) {
    if (text.trim().isEmpty) return;

    // Create the message object
    final newMessage = ChatModel(
      id: null, // Will be set by database
      sender: myName,
      message: text,
      time: DateTime.now().toString(),
    );

    // Add to local list immediately for instant UI update
    _messages.add(newMessage);
    notifyListeners();

    // Store in database
    _db.insertMessage({
      'sender': myName,
      'message': text,
      'time': DateTime.now().toString()
    });

    // Send to WebSocket server
    final payload = jsonEncode({
      'sender': myName,
      'message': text,
      'time': DateTime.now().toString()
    });
    _mgr.send(payload);
  }
}