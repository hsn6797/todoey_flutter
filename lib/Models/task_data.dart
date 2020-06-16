import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:todoeyflutter/Models/task.dart';

class TaskData extends ChangeNotifier {
  List<Task> _taskList = [
    Task(title: 'Buy Milk'),
    Task(title: 'Buy Eggs'),
    Task(title: 'make spreed sheet'),
    Task(title: 'going for shopping'),
  ];
  UnmodifiableListView<Task> get taskList {
    return UnmodifiableListView(_taskList);
  }

  int get taskCount {
    return _taskList.length;
  }

  void addTask(taskString) {
    final task = Task(title: taskString);
    _taskList.add(task);
    notifyListeners();
  }

  void updateTask(Task task) {
    task.toggleDone();
    notifyListeners();
  }

  void deleteTask(Task task) {
    _taskList.remove(task);
    notifyListeners();
  }
}
