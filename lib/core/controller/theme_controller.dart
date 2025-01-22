import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;
  @override
  void onInit() {
    super.onInit();
    loadThemeFromPrefs(); // Load the theme preference on app startup
  }

  Future<void> toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    await saveThemeToPrefs();
  }

  Future<void> saveThemeToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode.value);
  }

  Future<void> loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('isDarkMode')) {
      isDarkMode.value = prefs.getBool('isDarkMode')!;
    }
  }
}
