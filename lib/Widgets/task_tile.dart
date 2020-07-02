import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:todoeyflutter/Models/task.dart';
import 'package:provider/provider.dart';
import 'package:todoeyflutter/Models/task_data.dart';

class TaskTile extends StatefulWidget {
  final String title;
  bool isChecked = false;
  final Function checkboxCallback;
  final Function longPressCallback;
  final Task task;

  TaskTile(
      {@required this.title,
      this.isChecked,
      this.checkboxCallback,
      this.longPressCallback,
      this.task});

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  var icon = Icon(Icons.play_arrow);

  AudioPlayer audioPlayer = AudioPlayer();

//  String url = 'http://192.168.10.6:8888/todoey/uploads/audio/';
  String url = 'http://quranapp.masstechnologist.com/todoey/uploads/audio/';

  play(String audioName) async {
    Provider.of<TaskData>(context, listen: false).toggleLoading(true);
    int result = await audioPlayer.play(url + audioName);
    Provider.of<TaskData>(context, listen: false).toggleLoading(false);
    if (result == 1) {
      // success
    }
  }

  stop() async {
    int result = await audioPlayer.stop();
    if (result == 1) {
      // success
    }
  }

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        icon = Icon(Icons.play_arrow);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: widget.longPressCallback,
      title: Row(
        children: <Widget>[
          GestureDetector(
              onTap: () {
                if (widget.task.audioName != null &&
                    widget.task.audioName.isNotEmpty) {
                  if (audioPlayer.state == AudioPlayerState.PLAYING) {
                    setState(() {
                      icon = Icon(Icons.play_arrow);
                    });
                    stop();
                  } else {
                    setState(() {
                      icon = Icon(Icons.stop);
                    });
                    play(widget.task.audioName);
                  }
                } else {}
              },
              child: widget.task.audioName != null &&
                      widget.task.audioName.isNotEmpty
                  ? icon
                  : SizedBox(
                      width: 15.0,
                    )),
          SizedBox(
            width: 10.0,
          ),
          Text(
            widget.title,
            style: TextStyle(
                fontSize: 18.0,
                decoration: widget.isChecked
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          ),
        ],
      ),
      trailing: Checkbox(
        value: widget.isChecked,
        activeColor: Colors.yellow.shade700,
        onChanged: widget.checkboxCallback,
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
