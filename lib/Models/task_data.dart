import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:todoeyflutter/Models/task.dart';

class TaskData extends ChangeNotifier {
  List<Task> _taskList = [
    Task(title: 'Add any Task'),
  ];

  TaskData() {
    getAllTasks();
  }

  void getAllTasks() async {
    _taskList = await Task.tasks();
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
    await task.insertTask();
    _taskList.add(task);
    notifyListeners();
  }

  void updateTask(Task task) async {
    task.toggleDone();
    await task.updateTask();
    notifyListeners();
  }

  void deleteTask(Task task) async {
    _taskList.remove(task);
    await task.deleteTask();
    notifyListeners();
  }
}
