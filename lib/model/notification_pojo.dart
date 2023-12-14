/*
* Created by Ujjawal Panchal on 11/11/22.
*/
import 'package:practice/main.dart';
import 'package:practice/utils/utility.dart';

class NotificationItemPojo {
  final String id;
  String title;
  String body;

  NotificationItemPojo({
    required this.id,
    required this.title,
    required this.body,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
    };
  }

  factory NotificationItemPojo.fromMap(Map<String, dynamic> map) {
    return NotificationItemPojo(
      id: map['id'],
      title: map['title'],
      body: map['body'],
    );
  }
}

extension ExtTodo on NotificationItemPojo {
  Future save() async {
    return msgService.db.collection(collectionName).doc(id).set(toMap());
  }
}
