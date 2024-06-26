import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/ui/widgets/notification_details_screen.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('Todos');

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
      

  NotifyHelper() {
    tz.initializeTimeZones();
    initializeNotification();
  }

  initializeNotification() async {
    // For iOS Notifications
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    // For Android Notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("appicon");

    // Initializing the devices
    final InitializationSettings initializationSettings =
        InitializationSettings(
            iOS: initializationSettingsIOS,
            android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    Get.dialog(const Text("Welcome to Flutter"));
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      // Extract data from the payload
      final data = payload.split('|');
      final title = data[0];
      final description = data[1];
      String startTime = data[2];
      final endTime = data[3];

      // Navigate to the notification details screen
      Get.to(() => NotificationDetailsScreen(
            title: title,
            description: description,
            startTime: startTime,
            endTime: endTime,
          ));
    } else {
      print("Notification Done");
    }
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> fetchDataAndNotify({
    required String userUid,
    required String docId,
  }) async {
    Map<String, dynamic> data =
        await notificationData(userUid: userUid, docId: docId);
    displayNotification(title: data['title']!, body: data['description']!);
  }

  void displayNotification(
      {required String title, required String body}) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your_channel_id', 'your_channel_name',
            channelDescription: 'your_channel_description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            icon: 'appicon'); // Ensure this matches the icon resource name
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: 'item x');
  }

  Map<String, String> getTimeComponents(String time) {
    var parts = time.split(' ');
    var timeParts = parts[0].split(':');

    return {
      'hour': timeParts[0],
      'minute': timeParts[1],
      'period': parts[1],
    };
  }

  Future<void> scheduleNotificationBasedOnData({
    required String userUid,
    required String docId,
  }) async {
    Map<String, dynamic> data =
        await notificationData(userUid: userUid, docId: docId);

    String date = data['date'];
    String endTime = data['endTime'];
    int remind = data['remind'] ?? 5; // Provide a default value

    var timeComponents = getTimeComponents(endTime);
    int hour = int.parse(timeComponents['hour']!);
    int minute = int.parse(timeComponents['minute']!);
    String period = timeComponents['period']!;

    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    int newmin = minute - remind;
    if (newmin < 0) {
      newmin = 60 + newmin;
      hour -= 1;
      if (hour < 0) hour = 23;
    }

    DateTime now = DateTime.now();
    DateTime selectedDate = DateFormat.yMd().parse(date);
    DateTime selectedTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      hour,
      newmin,
    );

    // If the selected time is in the past, do not schedule the notification
    if (selectedTime.isAfter(now)) {
      await scheduledNotification2(
        title: data['title'],
        body: data['description'],
        scheduledTime: selectedTime,
        startTime: endTime,
      );
    } else {
      print('Scheduled time is in the past, notification not scheduled.');
    }
  }

  Future<void> scheduledNotification2({
    required String title,
    required String body,
    required DateTime scheduledTime,
    required String startTime,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          channelDescription: 'your_channel_description',
          importance: Importance.max,
          priority: Priority.high,
          icon: 'appicon', // Ensure this matches the icon resource name
        ),
      ),
      payload:
          '$title|$body|${DateFormat.Hm().format(scheduledTime)}|$startTime',
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  static Future<Map<String, dynamic>> notificationData({
    required String userUid,
    required String docId,
  }) async {
    DocumentReference documentReference =
        _mainCollection.doc(userUid).collection("userTodos").doc(docId);
    try {
      DocumentSnapshot documentSnapshot = await documentReference.get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        String title = data['title'] ?? 'No Title';
        String description = data['description'] ?? 'No description';
        String date = data['date'] ?? 'No date';
        String endTime = data['endTime'] ?? 'No endTime';
        int reminder = data['remind'] ?? 5;
        return {
          'title': title,
          'description': description,
          'date': date,
          'endTime': endTime,
          'reminder': reminder,
        };
      } else {
        print('No such doc');
        return {
          'title': 'No Title',
          'description': 'No description',
          'date': 'No date',
          'endTime': 'No endTime',
          'reminder': 5,
        };
      }
    } catch (e) {
      print('Error fetching document: $e');
      return {
        'title': 'Error',
        'description': 'Error',
        'date': 'Error',
        'endTime': 'Error',
        'reminder': 5,
      };
    }
  }
}
