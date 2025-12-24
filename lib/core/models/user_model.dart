//mendefinisi class UserModel buat isidata user dan data yg diperlu tu isinya ada id dll ini
class UserModel {
  final String id;
  final String name;
  final String email;
  final String imageUrl;
  final String? token;
  final String? job;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
    this.token,
    this.job
  });

//simpan data ke sqflite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'token': token,
      'job': job,
    };
  }
  //ambil data dari sqflite
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      imageUrl: map['imageUrl'],
      token: map['token'],
      job: map['job'],
    );
  }
}
