import 'package:flutter/material.dart';
import 'task_tile.dart';
import 'package:provider/provider.dart';
import 'package:todoeyflutter/Models/task_data.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class TasksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return ListView.builder(
          itemBuilder: (context, position) {
            final task = taskData.taskList[position];
            return TaskTile(
              title: task.title,
              isChecked: task.isDone,
              checkboxCallback: (bool checkboxState) {
                taskData.updateTask(task);
//                print(task.audioName);
              },
              longPressCallback: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.SCALE,
                  title: 'Delete Task',
                  desc: 'Are you sure? you want to delete this task',
                  btnCancelOnPress: () {},
                  btnOkOnPress: () {
                    taskData.deleteTask(task);
//                    Navigator.pop(context);
                  },
                )..show();
              },
              task: task,
            );
          },
          itemCount: taskData.taskCount,
        );
      },
    );
  }
}
