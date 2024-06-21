import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
            requestSoundPermission: false,
            requestBadgePermission: false,
            requestAlertPermission: false,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    // For Android Notifications
    final AndroidInitializationSettings initializationSettingsAndroid =
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
    if (notificationResponse.payload != null) {
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }
    Get.to(() => Container(
          color: Colors.blue,
        ));
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
            icon: 'appicon');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: 'item x');
  }

  Map<String, String> getTimeComponents(String time) {
    var parts = time.split(' ');
    var timeParts = parts[0].split('.');

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

    var timeComponents = getTimeComponents(endTime);
    int hour = int.parse(timeComponents['hour']!);
    int minute = int.parse(timeComponents['minute']!);
    String period = timeComponents['period']!;

    // Convert 12-hour format to 24-hour format
    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    DateTime now = DateTime.now();
    DateTime selectedDate = DateFormat.yMd().parse(date);
    DateTime selectedTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      hour,
      minute,
    );

    // If the selected time is in the past, schedule it for the next day
    if (selectedTime.isBefore(now)) {
      selectedTime = selectedTime.add(const Duration(days: 1));
    }

    // Schedule the notification
    await scheduledNotification2(
      title: data['title'],
      body: data['description'],
      scheduledTime: selectedTime,
    );
  }

  Future<void> scheduledNotification2({
    required String title,
    required String body,
    required DateTime scheduledTime,
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
          icon: 'appicon',
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
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
        String repeat = data['repeat'] ?? 'None';
        return {
          'title': title,
          'description': description,
          'date': date,
          'endTime': endTime,
          'reminder': reminder,
          'repeat': repeat
        };
      } else {
        print('No such doc');
        return {
          'title': 'No Title',
          'description': 'No description',
          'date': 'No date',
          'endTime': 'No endTime',
          'reminder': 'No',
          'repeat': 'No'
        };
      }
    } catch (e) {
      print('Error fetching document: $e');
      return {
        'title': 'Error',
        'description': 'Error',
        'date': 'Error',
        'endTime': 'Error'
      };
    }
  }
}
