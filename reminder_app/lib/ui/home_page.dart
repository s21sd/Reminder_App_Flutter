import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:reminder_app/db/db_helper.dart';
import 'package:reminder_app/models/task.dart';
import 'package:reminder_app/ui/add_task_bar.dart';
import 'package:reminder_app/ui/login_page.dart';
import 'package:reminder_app/ui/theme.dart';
import 'package:reminder_app/ui/widgets/buttons.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:reminder_app/services/notification_services.dart';
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
  DateTime _selectedDate = DateTime.now();
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
      appBar: _appBar(context),
      body: Column(
        children: [
          _addTaskBar(context),
          _addDateBar(),
          const SizedBox(
            height: 10,
          ),
          // _showTasks()
          _showTasksForDate(_selectedDate),
        ],
      ),
    );
  }

  // App bar implementation
  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
          onTap: () async {},
          child: Container(
            margin: const EdgeInsets.all(8),
            width: 40,
            child: widget.imgUrl != null
                ? CircleAvatar(
                    minRadius: 20,
                    maxRadius: 40,
                    backgroundImage: NetworkImage(widget.imgUrl!),
                  )
                : const CircleAvatar(
                    minRadius: 20,
                    maxRadius: 40,
                    backgroundImage: AssetImage('assets/images/user3.jpg'),
                  ),
          )),
      actions: [
        GestureDetector(
          onTap: () async {
            bool logoutConfirmed = await _showLogoutConfirmationDialog();
            if (logoutConfirmed) {
              await FirebaseServices().signOut();
              Get.offAll(const LoginPage());
            }
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

  // For the pop of log out
  Future<bool> _showLogoutConfirmationDialog() async {
    bool logoutConfirmed = false;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              logoutConfirmed = true;
              Navigator.of(context).pop();
              final snackBar = SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: 'Logout!',
                  message: 'Logout Successfully',
                  contentType: ContentType.success,
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
    return logoutConfirmed;
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
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 15),
      child: EasyDateTimeLine(
        initialDate: DateTime.now(),
        onDateChange: (selectedDate) {
          setState(() {
            _selectedDate = selectedDate;
            // Get the items based on the date
          });
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

  // Show the todos based on the date
  Widget _showTasksForDate(DateTime selectedDate) {
    String formatedDate = DateFormat('M/dd/yyyy').format(selectedDate);
    // await DbHelper.readItemsForDate(widget.userId!, formatedDate);
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: DbHelper.readItemsForDate(widget.userId!, formatedDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                    height: 300,
                    child: Lottie.asset('assets/animations/empty.json',
                        fit: BoxFit.contain,
                        width: 400,
                        height: 400,
                        repeat: true)),
                const Text('No tasks found.')
              ],
            ));
          }

          List<Task> tasks = snapshot.data!.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return Task(
              id: data['id'],
              title: data['title'],
              description: data['description'],
              isCompleted: data['isCompleted'],
              date: data['date'],
              startTime: data['startTime'],
              endTime: data['endTime'],
              color: data['color'],
              remind: data['remind'],
              repeat: data['repeat'],
            );
          }).toList();

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return GestureDetector(
                  onTap: () {},
                  child: AnimationConfiguration.staggeredList(
                      position: index,
                      child: SlideAnimation(
                        child: FadeInAnimation(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showBottomSheet(context, task);
                                },
                                child: TaskTile(task),
                              )
                            ],
                          ),
                        ),
                      )));
            },
          );
        },
      ),
    );
  }

// Show The Todos

  // Widget _showTasks() {
  //   return Expanded(
  //     child: StreamBuilder<QuerySnapshot>(
  //       stream: DbHelper.readItems(widget.userId!),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Center(child: CircularProgressIndicator());
  //         }
  //         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  //           return const Center(child: Text('No tasks found.'));
  //         }

  //         List<Task> tasks = snapshot.data!.docs.map((doc) {
  //           var data = doc.data() as Map<String, dynamic>;
  //           return Task(
  //             id: data['id'],
  //             title: data['title'],
  //             description: data['description'],
  //             isCompleted: data['isCompleted'],
  //             date: data['date'],
  //             startTime: data['startTime'],
  //             endTime: data['endTime'],
  //             color: data['color'],
  //             remind: data['remind'],
  //             repeat: data['repeat'],
  //           );
  //         }).toList();

  //         return ListView.builder(
  //           itemCount: tasks.length,
  //           itemBuilder: (context, index) {
  //             final task = tasks[index];
  //             return GestureDetector(
  //                 onTap: () {},
  //                 child: AnimationConfiguration.staggeredList(
  //                     position: index,
  //                     child: SlideAnimation(
  //                       child: FadeInAnimation(
  //                         child: Row(
  //                           children: [
  //                             GestureDetector(
  //                               onTap: () {
  //                                 _showBottomSheet(context, task);
  //                               },
  //                               child: TaskTile(task),
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                     )));
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }

  // For the buttom pop bar
  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 4),
      height: task.isCompleted == 1
          ? MediaQuery.of(context).size.height * 0.25
          : MediaQuery.of(context).size.height * 0.32,
      child: Column(
        children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.grey),
          ),
          const Spacer(),
          task.isCompleted == 1
              ? Container()
              : _bottomSheetButton(
                  label: "Task Completed",
                  onTap: () async {
                    await _updateTaskToDb(task);
                    // Get.back();
                    final snackBar = SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Updated!',
                        message: 'Task updated Successfully',
                        contentType: ContentType.success,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  clr: primaryClr,
                  context: context),
          _bottomSheetButton(
              label: "Delete Task",
              onTap: () async {
                await DbHelper.deleteItem(
                  userUid: widget.userId!,
                  docId: task.id.toString(),
                );
                Get.back();
                final snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: 'Deleted',
                    message: 'Task deleted Successfully',
                    contentType: ContentType.success,
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              clr: Colors.red,
              context: context),
          const SizedBox(
            height: 10,
          ),
          _bottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              isClose: true,
              clr: Colors.black,
              context: context),
        ],
      ),
    ));
  }

  _bottomSheetButton(
      {required String label,
      required Function()? onTap,
      required Color clr,
      required BuildContext context,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          height: 50,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isClose == true ? Colors.transparent : clr,
              border: Border.all(
                  width: 2, color: isClose == true ? Colors.grey : clr)),
          child: Center(
              child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ))),
    );
  }

  // for updating the todo
  Future<void> _updateTaskToDb(Task task) async {
    await DbHelper.updateItem(
      userUid: widget.userId!,
      docId: task.id!,
      title: task.title!,
      description: task.description!,
      date: task.date!,
      startTime: task.startTime!,
      endTime: task.endTime!,
      remind: task.remind!,
      color: task.color!,
      isCompleted: 1,
    );
  }
}
