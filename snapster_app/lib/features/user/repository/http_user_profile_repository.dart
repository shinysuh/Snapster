import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/features/user/services/http_user_profile_service.dart';

class HttpUserProfileRepository {
  final HttpUserProfileService _httpUserProfileService;

  HttpUserProfileRepository(this._httpUserProfileService);

  Future<void> updateUserProfile(AppUser updateUser) async {
    _httpUserProfileService.updateUserProfile(updateUser);
  }
}
