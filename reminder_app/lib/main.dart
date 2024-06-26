import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reminder_app/db/db_helper.dart';
import 'package:reminder_app/services/notification_services.dart';
import 'package:reminder_app/services/theme_services.dart';
import 'package:reminder_app/ui/splash_page.dart';
import 'package:reminder_app/ui/theme.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:notification_permissions/notification_permissions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Future<PermissionStatus> permissionStatus =
  //     NotificationPermissions.requestNotificationPermissions(
  //   iosSettings: const NotificationSettingsIos(
  //     sound: true,
  //     badge: true,
  //     alert: true,
  //   ),
  //   openSettings:
  //       true,
  // );
  // PermissionStatus status = await permissionStatus;
  // print(status);

  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyB6GjPE0dQ8-WDHwrPvGkXRmNMUEY-G8wI',
    appId: '1:876107566069:android:a6ab3dd7f0bbfc8426eebc',
    messagingSenderId: '876107566069',
    projectId: 'foodapp2-3a233',
    storageBucket: 'foodapp2-3a233.appspot.com',
  ));
  await GetStorage.init();

  final notifyHelper = NotifyHelper();
  notifyHelper.initializeNotification();

  notifyHelper.displayNotification(
      title: "Test Notification", body: "This is the test notification");

  final box = GetStorage();
  final userUid = box.read('userId') ?? 'defaultUserId';

  if (userUid != 'defaultUserId') {
    await DbHelper().scheduleAllTasksNotifications(userUid);
    DbHelper().listenForTaskChanges(userUid);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Remindify',
        debugShowCheckedModeBanner: false,
        theme: Themes.light,
        themeMode: ThemeService().theme,
        darkTheme: Themes.dark,
        home: const MySplashScreen());
  }
}
