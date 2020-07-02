import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todoeyflutter/Models/task.dart';

class TaskData extends ChangeNotifier {
  bool isLoading = false;

  List<Task> _taskList = [];

  TaskData(context) {
    getAllTasks();
  }

  void toggleLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  void getAllTasks() async {
//    _taskList = await Task.tasks();
//    notifyListeners();

    toggleLoading(true);
    _taskList = await Task.getTasks();
    _taskList.sort((b, a) => a.id.compareTo(b.id));

    toggleLoading(false);
  }

  UnmodifiableListView<Task> get taskList {
    return UnmodifiableListView(_taskList);
  }

  int get taskCount {
    return _taskList.length;
  }

  void addTask(taskString, audioPath, extention) async {
//    final task = Task(title: taskString);
//    await task.insertTask();
//    _taskList.add(task);
//    notifyListeners();

    toggleLoading(true);

    final task = Task(title: taskString);

    await task.postTask(audioPath, extention);

    _taskList.insert(0, task);

    toggleLoading(false);
  }

  void updateTask(Task task) async {
//    task.toggleDone();
//    await task.updateTask();
//    notifyListeners();
    toggleLoading(true);

    task.toggleDone();
    await task.putTask();

    toggleLoading(false);
  }

  void deleteTask(Task task) async {
//    _taskList.remove(task);
//    await task.removeTask();
//    notifyListeners();
    toggleLoading(true);

    await task.deleteTask();
    _taskList.remove(task);

    toggleLoading(false);
  }
}
