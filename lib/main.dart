import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoeyflutter/Screens/task_screen.dart';
import 'package:todoeyflutter/Models/task_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  double percentage = 0.0;

  @override
  Widget build(BuildContext context) {
    // Custom body test

    return ChangeNotifierProvider(
      create: (context) => TaskData(context),
      child: MaterialApp(
        home: TasksScreen(),
      ),
    );
  }
}
