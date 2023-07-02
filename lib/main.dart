import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_progress_tracker/db/db_helper.dart';
import 'package:my_progress_tracker/services/theme_services.dart';
import 'package:my_progress_tracker/ui/home.dart';
import 'package:my_progress_tracker/ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDB();
  await GetStorage.init();
  await DBHelper.createBoard();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // GetMaterialApp is used instead MaterialApp to reflect changes using Get
    return GetMaterialApp(
        title: 'Flutter Demo',
        theme: Themes.light,
        darkTheme: Themes.dark,
        themeMode: ThemeService().theme,
        home: HomePage());
  }
}
