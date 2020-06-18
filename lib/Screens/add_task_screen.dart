import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoeyflutter/Models/task_data.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  @override
  Widget build(BuildContext context) {
    String typedValue;

    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Add Task',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w800,
                color: Colors.yellow.shade700,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextField(
              onChanged: (value) {
                typedValue = value;
              },
              autofocus: true,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide:
                      BorderSide(width: 1, color: Colors.yellow.shade700),
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 25.0,
              ),
            ),
            FlatButton(
              child: Text(
                'Add',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
              color: Colors.yellow.shade700,
              onPressed: () {
                Provider.of<TaskData>(context, listen: false)
                    .addTask(typedValue);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
