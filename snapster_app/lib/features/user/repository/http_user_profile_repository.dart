import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/features/user/services/http_user_profile_service.dart';

class HttpUserProfileRepository {
  final HttpUserProfileService _userProfileService;

  HttpUserProfileRepository(this._userProfileService);

  Future<List<AppUser>> getAllOtherUsers() async {
    return _userProfileService.getAllOtherUsers();
  }

  Future<void> updateUserProfile(AppUser updateUser) async {
    _userProfileService.updateUserProfile(updateUser);
  }
}
