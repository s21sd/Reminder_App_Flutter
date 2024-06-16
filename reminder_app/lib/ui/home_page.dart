import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';// Assuming the correct import for AddTaskPage
import 'package:reminder_app/ui/add_task_bar.dart';
import 'package:reminder_app/ui/login_page.dart';
import 'package:reminder_app/ui/theme.dart';
import 'package:reminder_app/ui/widgets/buttons.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';// Assuming the correct import for FirebaseServices
import 'package:reminder_app/services/notification_services.dart';
import 'package:reminder_app/services/theme_services.dart';
import 'package:reminder_app/ui/widgets/google_auth.dart';

class HomePage extends StatefulWidget {
  final String? imgUrl;
  final String? userId;

  const HomePage({Key? key, required this.imgUrl, this.userId})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotifyHelper notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    // notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Column(
        children: [
          _addTaskBar(context),
          _addDateBar(),
        ],
      ),
    );
  }

  // App bar implementation
  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        onTap: () async {
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
            title: "Theme Changed",
            body:
                Get.isDarkMode ? "Activated Dark Mode" : "Activated Light Mode",
          );
        },
        child: Icon(
          Get.isDarkMode
              ? Icons.wb_sunny_outlined
              : Icons.nightlight_round_sharp,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        if (widget.imgUrl != null)
          CircleAvatar(
            backgroundImage: NetworkImage(widget.imgUrl!),
          )
        else
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/user3.jpg'),
          ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () async {
            await FirebaseServices().signOut();
            Get.offAll(const LoginPage());
          },
          child: const Icon(
            Icons.logout,
            size: 30,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  // Task bar implementation
  Widget _addTaskBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                "Today",
                style: headingStyle,
              )
            ],
          ),
          MyButton(
            label: "+ Add Task",
            onTap: () {
              Get.to(() => AddTaskPage(
                  userId: widget.userId)); // Passing userId to AddTaskPage
            },
          ),
        ],
      ),
    );
  }

  // Date bar picker implementation
  Widget _addDateBar() {
    DateTime _selectedDate = DateTime.now();
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 15),
      child: EasyDateTimeLine(
        initialDate: DateTime.now(),
        onDateChange: (selectedDate) {
          _selectedDate = selectedDate;
        },
        headerProps: const EasyHeaderProps(showHeader: false),
        activeColor: primaryClr,
        dayProps: EasyDayProps(
          height: 100,
          width: 80,
          activeDayStyle: DayStyle(
            monthStrStyle: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            dayStrStyle: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            dayNumStyle: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          todayHighlightStyle: TodayHighlightStyle.withBackground,
        ),
      ),
    );
  }
}
