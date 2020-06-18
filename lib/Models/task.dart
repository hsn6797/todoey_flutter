import 'package:flutter/cupertino.dart';
import 'package:todoeyflutter/Database/database_helper.dart';

class Task {
  int id;
  final String title;
  bool isDone;

  static DatabaseHelper dh;

  Task({this.id, @required this.title, this.isDone = false}) {
    dh = DatabaseHelper.instance;
  }

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

  // SQFLite Database functions

  Future<void> insertTask() async {
    int id = await dh.insert(this.toMap());
    this.id = id;
  }

  Future<void> updateTask() async {
    // Get a reference to the database.
    int rowsAffected = await dh.update(this.toMap());
  }

  Future<void> deleteTask() async {
    int rowsAffected = await dh.delete(this.id);
  }

  static Future<List<Task>> tasks() async {
    // Query the table for all The Tasks.
    final List<Map<String, dynamic>> maps = await dh.queryAllRows();

    // Convert the List<Map<String, dynamic> into a List<Task>.
    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        title: maps[i]['title'],
        isDone: intTobool(maps[i]['isDone']),
      );
    });
  }
}
