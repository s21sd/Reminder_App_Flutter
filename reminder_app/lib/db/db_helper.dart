import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('Todos');

class DbHelper {
  static String? userUid = 'wnMkvUGdEwSnNRyMc3AS0jjez2z1';

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
}
