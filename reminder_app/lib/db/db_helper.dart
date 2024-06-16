import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('Todos');

class DbHelper {
  static String? userUid = 'wnMkvUGdEwSnNRyMc3AS0jjez2z1';

  // For Writing the data
  static Future<void> addItem({
    required String title,
    required String description,
    required String date,
    required String startTime,
    required String endTime,
    required int remind,
    required String repeat,
    required int color,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('userTodos').doc();

    Map<String, dynamic> data = <String, dynamic>{
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
        .whenComplete(() => print("Todos item added to the database"))
        .catchError((e) => print(e));
  }

  // For Reading the data
  static Stream<QuerySnapshot> readItems(String userid) {
    CollectionReference todoItemCollection =
        _mainCollection.doc(userid).collection('userTodos');
    return todoItemCollection.snapshots();
  }

  // For Deleting Data
  static Future<void> deleteItem({
    required String docId,
  }) async {

    DocumentReference documentReference =
        _mainCollection.doc(userUid).collection("userTodos").doc(docId);

    await documentReference
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }

  //For updating the data I will take care the rest
  static Future<void> updateItem(
      {required String docId,
      required String title,
      required String description,
      required String date,
      required String startTime,
      required String endTime,
      required int remind,
      required String repeat,
      required int color,
      required int isCompleted}) async {
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
        .whenComplete(() => print("Note item updated in the database"))
        .catchError((e) => print(e));
  }
}
