import 'package:flutter/cupertino.dart';

class Task {
  int id;
  final String title;
  bool isDone;

  Task({this.id, @required this.title, this.isDone = false});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'isDone': isTaskDone(),
    };
    if (id != null) map['id'] = id;

    return map;
  }

  int isTaskDone() {
    return isDone ? 1 : 0;
  }

  static bool intTobool(int val) {
    return val == 1 ? true : false;
  }

  void toggleDone() {
    isDone = !isDone;
  }
}
