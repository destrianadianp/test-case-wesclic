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
}