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

  factory UserModel.fromLoginResponse(String email, String token){
    return UserModel(
      id: 'reqres_user',
      name: email,
      email: email,
      imageUrl: 'https://i.pravatar.cc/150?img=1',
      token: token);
  }
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: '${json['first_name']} ${json['last_name']}',
      email: json['email'],
      imageUrl: json['avatar'],
      job: json['job'], // Add job field parsing
    );
  }
  factory UserModel.fromCRUD(Map<String, dynamic> json, {required String email, String? id}){
    return UserModel(
      id: json['id']?.toString() ?? id ?? '0',
    name: json['name'] ?? '',
    email: json['email'] ?? email,
    imageUrl: json['avatar'] ?? 'https://i.pravatar.cc/150?img=default',
    job: json['job']
      );
  }
}