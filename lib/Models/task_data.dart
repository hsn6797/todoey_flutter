import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:todoeyflutter/Database/database.dart';
import 'package:todoeyflutter/Models/task.dart';

class TaskData extends ChangeNotifier {
  DatabaseHelper db;
  List<Task> _taskList = [
    Task(title: 'Add any Task'),
  ];

  TaskData() {
    db = DatabaseHelper();
    getAllTasks();
  }

  void getAllTasks() async {
    await db.openConnection();
    _taskList = await db.tasks();
    notifyListeners();
  }

  UnmodifiableListView<Task> get taskList {
    return UnmodifiableListView(_taskList);
  }

  int get taskCount {
    return _taskList.length;
  }

  void addTask(taskString) async {
    final task = Task(title: taskString);
    _taskList.add(task);
    await db.insertTask(task);
    notifyListeners();
  }

  void updateTask(Task task) async {
    task.toggleDone();
    await db.updateTask(task);
    notifyListeners();
  }

  void deleteTask(Task task) async {
    _taskList.remove(task);
    await db.deleteTask(task.id);
    notifyListeners();
  }
}
