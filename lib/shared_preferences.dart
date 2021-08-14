import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  static late SharedPreferences sharedPreferences;

  static const String userIdKey = 'UserID';
  static const String userNameKey = 'UserName';
  static const String displayNameKey = 'DisplayName';
  static const String emailKey = 'Email';
  static const String userProfileKey = 'UserProfile';
}
