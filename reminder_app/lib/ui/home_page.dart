import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reminder_app/services/notification_services.dart';
import 'package:reminder_app/services/theme_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  late NotifyHelper notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: const Column(
        children: [
          Text(
            "Theme Data",
            style: TextStyle(fontSize: 30),
          ),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation:0,
      leading: GestureDetector(
        onTap: () async {
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
              title: "Theme Changed",
              body: Get.isDarkMode
                  ? "Activated Dark Mode"
                  : "Activated Light Mode");
        },
        child: Icon(
            Get.isDarkMode
                ? Icons.wb_sunny_outlined
                : Icons.nightlight_round_sharp,
            size: 20,
            color: Get.isDarkMode ? Colors.white : Colors.black),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage('assets/images/user3.jpg'),
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }
}
