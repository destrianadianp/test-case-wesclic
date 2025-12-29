class ChatModel {
 final int? id;
 final String sender;
 final String message;
 final String time;

 ChatModel({
  this.id,
  required this.sender,
  required this.message,
  required this.time
 });
 Map<String, dynamic> toMap()=>{
   'sender':sender,
   'message':message,
   'time':time
 };

 factory ChatModel.fromMap(Map<String, dynamic> map){
   return ChatModel(
     id: map['id'],
     sender: map['sender'],
     message: map['message'],
     time: map['time']
   );
 }
}