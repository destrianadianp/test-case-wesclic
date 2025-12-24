import '../../../core/models/user_model.dart';
import '../../home/services/home_api_service.dart';

class UserListApiService {
  final HomeApiService _homeApiService = HomeApiService();

  Future<List<UserModel>> getAllUsers() async {
    return await _homeApiService.getAllUsers();
  }
}