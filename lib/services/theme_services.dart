import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_progress_tracker/services/user_detail_service.dart';

class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }

  static Color getBGClr(int no) {
    switch (no) {
      case 0:
        return Color(0xFFfd7f6f);
      case 1:
        return Color(0xFF7eb0d5);
      case 2:
        return Color(0xFFb2e061);
      case 3:
        return Color(0xFFbd7ebe);
      case 4:
        return Color(0xFFffb55a);
      case 5:
        return Color(0xFFffee65);
      case 6:
        return Color(0xFFbeb9db);
      case 7:
        return Color(0xFFfdcce5);
      case 8:
        return Color(0xFF8bd3c7);
      case 9:
        return Color(0xFFF5D6B1);
      default:
        return Color(0xFF6cd4c5);
    }
  }

  static Color getAppPrimaryClr(int no) {
    switch (no) {
      case 0:
        return Color.fromARGB(255, 120, 64, 217);
      case 1:
        return Color.fromARGB(255, 215, 102, 22);
      case 2:
        return Color.fromARGB(255, 25, 156, 173);
      case 3:
        return Color.fromARGB(255, 191, 8, 208);
      case 4:
        return Color.fromARGB(255, 85, 124, 16);
      case 5:
        return Color(0xFF007FFF);
      default:
        return Color.fromARGB(255, 120, 64, 217);
    }
  }

  static getBoardIcon(String boardName) {
    switch (boardName) {
      case "Work":
        return Icon(
          Icons.work,
          size: 45,
          color: Color(0xFF454545),
        );
        break;
      case "Self care":
        return Icon(
          Icons.self_improvement,
          size: 45,
          color: Color(0xFF454545),
        );
        break;
      case "Fitness":
        return Icon(
          Icons.fitness_center,
          size: 45,
          color: Color(0xFF454545),
        );
        break;
      case "Learn":
        return Icon(
          Icons.book,
          size: 45,
          color: Color(0xFF454545),
        );
        break;
      case "Errand":
        return Icon(
          Icons.route_outlined,
          size: 45,
          color: Color(0xFF454545),
        );
        break;
      default:
        return Icon(
          Icons.category,
          size: 45,
          color: Color(0xFF454545),
        );
        break;
    }
  }

  static getBoardIconForDetail(String boardName) {
    switch (boardName) {
      case "Work":
        return Icon(Icons.work, size: 30, color: ColorConstants.iconColor);
        break;
      case "Self care":
        return Icon(Icons.self_improvement,
            size: 30, color: ColorConstants.iconColor);
        break;
      case "Fitness":
        return Icon(Icons.fitness_center,
            size: 30, color: ColorConstants.iconColor);
        break;
      case "Learn":
        return Icon(Icons.book, size: 30, color: ColorConstants.iconColor);
        break;
      case "Errand":
        return Icon(Icons.route_outlined,
            size: 30, color: ColorConstants.iconColor);
        break;
      default:
        return Icon(Icons.category, size: 30, color: ColorConstants.iconColor);
        break;
    }
  }
}

class ColorConstants {
  static var iconColor = ThemeService.getAppPrimaryClr(
      UserDetailService().selectedPrimaryColorIndex);
  static var buttonColor = ThemeService.getAppPrimaryClr(
      UserDetailService().selectedPrimaryColorIndex);

  static const headingColor = Colors.black87;
  static const headingColorLight = Colors.white;

  static const subHeadingColor = Colors.black;
  static const subHeadingColorLight = Colors.white70;

  static const textColor = Colors.black87;
  static const textColorLight = Colors.black87;
  static const textColorWhite = Colors.white;

  static const alertLightBg = Colors.white;
  static const alertDarkBg = Colors.black87;

  static const progressColor = Color.fromARGB(221, 63, 216, 69);

  static updatePrimaryColorCode(Color color) {
    buttonColor = color;
    iconColor = color;
  }
}
