import 'package:flutter/cupertino.dart';
import 'package:todoeyflutter/Database/database_helper.dart';
import 'package:todoeyflutter/Services/network_helper.dart';

class Task {
  int id;
  final String title;
  bool isDone;

  static DatabaseHelper dh;
//  static const TODOEY_API_URL =
//      "http://192.168.10.6:8888/todoey/controllers/task_controller.php";
  static const TODOEY_API_URL =
      "http://quranapp.masstechnologist.com/todoey/controllers/task_controller.php";

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

  Future<void> removeTask() async {
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

  // Web API functions
  static Future<dynamic> getTaskById(String id) async {
    NetworkHelper helper = NetworkHelper("$TODOEY_API_URL?"
        "id=$id");

    var taskData = await helper.getData();
    return Task(
      id: int.parse(taskData['id']),
      title: taskData['title'],
      isDone: intTobool(int.parse(taskData['isDone'])),
    );
  }

  static Future<List<Task>> getTasks() async {
    NetworkHelper helper = NetworkHelper(TODOEY_API_URL);
    var tasksData = await helper.getData();
    // Convert the List<Map<String, dynamic> into a List<Task>.
    return List.generate(tasksData.length, (i) {
      return Task(
        id: int.parse(tasksData[i]['id']),
        title: tasksData[i]['title'],
        isDone: intTobool(int.parse(tasksData[i]['isDone'])),
      );
    });
  }

  Future<void> postTask() async {
    NetworkHelper helper = NetworkHelper(TODOEY_API_URL);
    var newTask = await helper.postData(this.toMap());
    print(newTask);
    int id = newTask["id"];
    this.id = id;
  }

  Future<void> putTask() async {
    // Get a reference to the database.
    NetworkHelper helper = NetworkHelper(TODOEY_API_URL);
    var newTask = await helper.putData(this.toMap());
  }

  Future<void> deleteTask() async {
    NetworkHelper helper = NetworkHelper("$TODOEY_API_URL?"
        "id=$id");
    var newTask = await helper.deleteData();
  }
}
