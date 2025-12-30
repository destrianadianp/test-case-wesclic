import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_case_skill/modules/socket_manager/socket_viewmodel.dart';

class SocketView extends StatefulWidget {
  @override
  _SocketViewState createState() => _SocketViewState();
}

class _SocketViewState extends State<SocketView> {
  final TextEditingController _ctrl = TextEditingController();
  String? myNickname;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      // Coba ambil nickname dari SharedPreferences dulu, jika tidak ada buat yang baru
      final prefs = await SharedPreferences.getInstance();
      String? savedNickname = prefs.getString('chat_nickname');

      if (savedNickname == null) {
        // Buat nickname baru dan simpan
        myNickname = "User-${DateTime.now().millisecondsSinceEpoch.toString().substring(10)}";
        await prefs.setString('chat_nickname', myNickname!);
      } else {
        // Gunakan nickname yang sudah ada
        myNickname = savedNickname;
      }

      context.read<SocketViewmodel>().initSocket(myNickname!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SocketViewmodel>();
    return Scaffold(
      appBar: AppBar(title: Text("Global Chat (${myNickname ?? 'Connecting...'})")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: vm.messages.length,
              itemBuilder: (context, i) {
                final m = vm.messages[i];
                // Gunakan nickname dari ViewModel untuk membandingkan
                bool isMe = m.sender == vm.myName;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(m.sender, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                        Text(m.message),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _ctrl, decoration: InputDecoration(hintText: "Ketik pesan..."))),
                IconButton(icon: Icon(Icons.send), onPressed: () {
                  if (_ctrl.text.isNotEmpty && myNickname != null) {
                    vm.sendMessage(_ctrl.text, myNickname!);
                    _ctrl.clear();
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}