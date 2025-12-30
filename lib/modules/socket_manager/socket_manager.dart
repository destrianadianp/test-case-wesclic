import 'dart:async';
import 'package:web_socket_channel/io.dart';

class SocketManager {
  static final SocketManager shared = SocketManager._();
  SocketManager._();

  IOWebSocketChannel? _channel;
  // Consider using environment variables or config for URL
  final String _url = 'wss://13a9ccb305b3.ngrok-free.app';
  
  StreamSubscription? _subscription;

  void connect() {
    // Close existing connection if it exists
    disconnect();
    
    try {
      _channel = IOWebSocketChannel.connect(Uri.parse(_url));
      print("Socket Connected to $_url");
    } catch (e) {
      print("Error connecting to WebSocket: $e");
    }
  }

  void send(String data) {
    if (_channel != null) {
      _channel!.sink.add(data);
    } else {
      print("WebSocket not connected. Cannot send data: $data");
    }
  }
  
  Stream? get stream => _channel?.stream;
  
  void disconnect() {
    _subscription?.cancel();
    _channel?.sink.close();
    _channel = null;
  }
  
  bool get isConnected => _channel != null;
}