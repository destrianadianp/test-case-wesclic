import 'package:web_socket_channel/io.dart';

class SocketManager {
  static final SocketManager shared = SocketManager._();
  SocketManager._();

  IOWebSocketChannel? _channel;
  // URL public piesocket
  final String _url = 'wss://free.piesocket.com/v3/chat_room_huda?api_key=VCXCEuvhGcBDP7XhiJJrvUDvR1eCc4unSMRefCH8&notify_self=1';

  void connect() {
    _channel = IOWebSocketChannel.connect(Uri.parse(_url));
    print("Socket Connected");
  }

  void send(String data) => _channel?.sink.add(data);
  Stream? get stream => _channel?.stream;
  void disconnect() => _channel?.sink.close();
}