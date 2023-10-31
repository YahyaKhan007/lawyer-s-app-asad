import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static SharedPreferences? preferences;

  // Ensure that you're using the same instance of SharedPreferences.
  static Future<SharedPreferences> getSharedPreferences() async {
    preferences ??= await SharedPreferences.getInstance();
    return preferences!;
  }
}
