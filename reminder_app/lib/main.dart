import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reminder_app/services/theme_services.dart';
import 'package:reminder_app/ui/home_page.dart';
import 'package:reminder_app/ui/login_page.dart';
import 'package:reminder_app/ui/splash_page.dart';
import 'package:reminder_app/ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: Themes.light,
        themeMode: ThemeService().theme,
        darkTheme: Themes.dark,
        home: const LoginPage());
  }
}
