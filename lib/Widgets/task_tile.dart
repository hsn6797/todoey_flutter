import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final String title;
  bool isChecked = false;
  final Function checkboxCallback;
  final Function longPressCallback;

  TaskTile(
      {@required this.title,
      this.isChecked,
      this.checkboxCallback,
      this.longPressCallback});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: longPressCallback,
      title: Text(
        title,
        style: TextStyle(
            fontSize: 18.0,
            decoration:
                isChecked ? TextDecoration.lineThrough : TextDecoration.none),
      ),
      trailing: Checkbox(
        value: isChecked,
        activeColor: Colors.yellow.shade700,
        onChanged: checkboxCallback,
      ),
    );
  }
}

//class TaskCheckbox extends StatelessWidget {
//  final bool checkBoxState;
//  final Function toggleCheckboxState;
//
//  TaskCheckbox(
//      {@required this.checkBoxState, @required this.toggleCheckboxState});
//
//  @override
//  Widget build(BuildContext context) {
//    return Checkbox(
//      value: checkBoxState,
//      activeColor: Colors.yellow.shade700,
//      onChanged: toggleCheckboxState,
//    );
//  }
//}
