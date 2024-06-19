import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:uuid/uuid.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('Todos');
final _firebaseMessaging = FirebaseMessaging.instance;
final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class DbHelper {
  // For Writing the data
  static Future<void> addItem({
    required String userUid,
    required String title,
    required String description,
    required String date,
    required String startTime,
    required String endTime,
    required int remind,
    required String repeat,
    required int color,
  }) async {
    var uuid = Uuid();
    var random_id = uuid.v4();
    DocumentReference documentReferencer = _mainCollection
        .doc(userUid)
        .collection('userTodos')
        .doc(
            random_id); // This line is so imp we have to add the actual id so that We can Use it for later

    Map<String, dynamic> data = <String, dynamic>{
      "id": random_id,
      "title": title,
      "description": description,
      "date": date,
      "startTime": startTime,
      "endTime": endTime,
      "remind": remind,
      "repeat": repeat,
      "color": color,
      "isCompleted": 0,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Todo item added to the database"))
        .catchError((e) => print(e));
  }

  // For Reading the data
  static Stream<QuerySnapshot> readItems(String userUid) {
    CollectionReference todoItemCollection =
        _mainCollection.doc(userUid).collection('userTodos');
    return todoItemCollection.snapshots();
  }

  // For Deleting Data
  static Future<void> deleteItem({
    required String userUid,
    required String docId,
  }) async {
    DocumentReference documentReference =
        _mainCollection.doc(userUid).collection("userTodos").doc(docId);

    await documentReference
        .delete()
        .whenComplete(() => print('Todo item deleted from the database'))
        .catchError((e) => print(e));
  }

  // For Updating Data
  static Future<void> updateItem({
    required String userUid,
    required String docId,
    required String title,
    required String description,
    required String date,
    required String startTime,
    required String endTime,
    required int remind,
    required String repeat,
    required int color,
    required int isCompleted,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('userTodos').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
      "date": date,
      "startTime": startTime,
      "endTime": endTime,
      "remind": remind,
      "repeat": repeat,
      "color": color,
      "isCompleted": isCompleted,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Todo item updated in the database"))
        .catchError((e) => print(e));
  }

// For Getting the Todos on a specific date

  static Stream<QuerySnapshot> readItemsForDate(
      String userUid, String selectedDate) {
    CollectionReference todoItemCollection = FirebaseFirestore.instance
        .collection('Todos')
        .doc(userUid)
        .collection('userTodos');

    Query query = todoItemCollection.where('date',
        isEqualTo: selectedDate); // Learn About the firebase query fucntions
    return query.snapshots();
  }

  
  // fetching the data for the notification from the firebase
  static Future<Map<String, String>> notificationData({
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
        return {'title': title, 'description': description};
      } else {
        print('No such doc');
        return {'title': 'No Title', 'description': 'No description'};
      }
    } catch (e) {
      print('Error fetching document: $e');
      return {'title': 'Error', 'description': 'Error'};
    }
  }
}
