import 'package:pagination_and_theme_task/core/constants/app_strings.dart';
import 'package:pagination_and_theme_task/core/storage/cache_helper.dart';

class UserHelper {
  static bool isLogin() {
    return AppSharedPreferences.getString(key: AppStrings.accessToken) != null;
  }

  static bool isAgent() {
    return AppSharedPreferences.getInt(key: AppStrings.appRole) == 0;
  }
}
