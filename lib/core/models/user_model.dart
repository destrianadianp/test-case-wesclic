//mendefinisi class UserModel buat isidata user dan data yg diperlu tu isinya ada id dll ini
class UserModel {
  final String id;
  final String name;
  final String email;
  final String imageUrl;
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
    this.token
  });

  factory UserModel.fromLoginResponse(String email, String token){
    return UserModel(
      id: 'reqres_user', 
      name: email, 
      email: email, 
      imageUrl: 'https://i.pravatar.cc/150?img=1', 
      token: token);
  }
  }
