import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/models/task.dart';
import 'package:reminder_app/ui/add_task_bar.dart';
import 'package:reminder_app/ui/login_page.dart';
import 'package:reminder_app/ui/theme.dart';
import 'package:reminder_app/ui/widgets/buttons.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:reminder_app/services/notification_services.dart';
import 'package:reminder_app/services/theme_services.dart';
import 'package:reminder_app/ui/widgets/google_auth.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:reminder_app/ui/widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  final String? imgUrl;
  final String? userId;

  const HomePage({super.key, required this.imgUrl, this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotifyHelper notifyHelper;
  List<Task> dummyTasks = [
    Task(
      id: 1,
      title: 'Task 1',
      note: 'This is the note for Task 1',
      isCompleted: 0,
      date: '2024-06-17',
      startTime: '10:00 AM',
      endTime: '11:00 AM',
      color: 0,
      remind: 10,
      repeat: 'Daily',
    ),
    Task(
      id: 2,
      title: 'Task 2',
      note: 'This is the note for Task 2',
      isCompleted: 1,
      date: '2024-06-18',
      startTime: '02:30 PM',
      endTime: '03:30 PM',
      color: 1,
      remind: 15,
      repeat: 'Weekly',
    ),
    Task(
      id: 3,
      title: 'Task 3',
      note: 'This is the note for Task 3',
      isCompleted: 0,
      date: '2024-06-19',
      startTime: '08:00 AM',
      endTime: '09:00 AM',
      color: 2,
      remind: 20,
      repeat: 'Monthly',
    ),
  ];
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
          const SizedBox(
            height: 10,
          ),
          _showTasks()
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

// Show The Todos
  _showTasks() {
    return Expanded(
      child: ListView.builder(
        itemCount: dummyTasks.length,
        itemBuilder: (context, index) {
          final task = dummyTasks[index];
          return GestureDetector(
              onTap: () {
                delete;
              },
              child: AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: TaskTile(task),
                          )
                        ],
                      ),
                    ),
                  )));
        },
      ),
    );
  }

  // for Deleting the todos
  void delete() {}
}
