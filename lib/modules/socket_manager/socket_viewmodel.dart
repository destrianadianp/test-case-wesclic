import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:test_case_skill/core/database/database_helper.dart';
import 'package:test_case_skill/core/models/chat_model.dart';
import 'package:test_case_skill/modules/socket_manager/socket_manager.dart';


class SocketViewModel extends ChangeNotifier {
  final SocketManager _mgr = SocketManager.shared;
  final DatabaseHelper _db = DatabaseHelper();
  List<ChatModel> messages = [];
  String? _myName; // Untuk menyimpan nama pengguna saat ini

  String? get myName => _myName;

  SocketViewModel() {
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    final data = await _db.getAllMessages();
    messages = data.map((e) => ChatModel.fromMap(e)).toList();
    notifyListeners();
  }

  void initSocket(String myName) {
    _myName = myName; // Simpan nama pengguna
    _mgr.connect();
    _mgr.stream?.listen((event) async {
      final decoded = jsonDecode(event);
      // Simpan pesan yang masuk dari server ke SQLite
      await _db.insertMessage({
        'sender': decoded['sender'],
        'message': decoded['message'],
        'time': DateTime.now().toString(),
      });
      fetchHistory();
    });
  }

  void clearMyName() {
    _myName = null;
  }

  void sendMessage(String text, String myName) {
    // Buat pesan lokal untuk ditampilkan segera di UI
    final localMessage = ChatModel(
      sender: myName,
      message: text,
      time: DateTime.now().toString(),
    );

    // Tambahkan langsung ke daftar pesan dan update UI
    messages.add(localMessage);
    notifyListeners();

    // Kirim ke WebSocket server
    final payload = jsonEncode({'sender': myName, 'message': text});
    _mgr.send(payload);
  }
}