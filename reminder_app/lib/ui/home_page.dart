import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reminder_app/services/notification_services.dart';
import 'package:reminder_app/services/theme_services.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/ui/add_task_bar.dart';
import 'package:reminder_app/ui/theme.dart';
import 'package:reminder_app/ui/widgets/buttons.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';

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
    // notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [_addTaskBar(context), _addDateBar()],
      ),
    );
  }

  // This is for the app bar
  _appBar() {
    return AppBar(
      // elevation: 0,
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

// This is for the time and add task button

_addTaskBar(BuildContext context) {
  return (Container(
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
        MyButton(label: "+ Add Task", onTap: () => Get.to(const AddTaskPage()))
      ],
    ),
  ));
}

// This is for the date bar picker
_addDateBar() {
  DateTime _selectDate = DateTime.now();
  return Container(
    margin: const EdgeInsets.only(top: 20, left: 15),
    child: EasyDateTimeLine(
      initialDate: DateTime.now(),
      onDateChange: (selectedDate) {
        _selectDate = selectedDate;
      },
      headerProps: const EasyHeaderProps(showHeader: false),
      activeColor: primaryClr,
      dayProps: EasyDayProps(
        height: 100,
        width: 80,
        activeDayStyle: DayStyle(
            monthStrStyle: GoogleFonts.lato(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
            dayStrStyle: GoogleFonts.lato(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
            dayNumStyle: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        todayHighlightStyle: TodayHighlightStyle.withBackground,
      ),
    ),
  );
}
