import 'package:get_storage/get_storage.dart';

class UserDetailService {
  final _box = GetStorage();
  final _keyUserName = 'userName';
  final _keyProfileImage = 'profilePic';
  final _keySelectedPrimaryColor = 'primaryColor';
  final _keyNotificationEnabled = 'notificationEnabled';

  String? _loadUserNameFromBox() => _box.read(_keyUserName) ?? null;
  String? _loadProfileImageFromBox() => _box.read(_keyProfileImage);
  int? _loadSelectedPrimaryColorFromBox() =>
      _box.read(_keySelectedPrimaryColor);
  bool? _loadNotificationEnabledFromBox() => _box.read(_keyNotificationEnabled);

  String? get userName => _loadUserNameFromBox();
  String? get profileImagePath => _loadProfileImageFromBox();
  int get selectedPrimaryColorIndex => _loadSelectedPrimaryColorFromBox() ?? 0;
  bool? get isNotificationEnabled => _loadNotificationEnabledFromBox();

  _saveUserNameToBox(String newName) => _box.write(_keyUserName, newName);
  _saveProfilePicPathToBox(String? imgFilePath) =>
      _box.write(_keyProfileImage, imgFilePath);
  _savePrimaryColorIndexToBox(int newIndex) =>
      _box.write(_keySelectedPrimaryColor, newIndex);
  _saveNotificationEnabledToBox(bool newIndex) =>
      _box.write(_keyNotificationEnabled, newIndex);

  void updateUserName(String userName) {
    _saveUserNameToBox(userName);
  }

  void updateProfilePic(String? filePath) {
    _saveProfilePicPathToBox(filePath);
  }

  void updatePrimaryColorIndex(int newIndex) {
    _savePrimaryColorIndexToBox(newIndex);
  }

  void updateNotificationEnanbled(bool isEnabled) {
    _saveNotificationEnabledToBox(isEnabled);
  }
}
