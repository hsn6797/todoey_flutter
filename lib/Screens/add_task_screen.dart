import 'dart:io';
import 'dart:io' as io;
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'package:audio_recorder/audio_recorder.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:todoeyflutter/Models/task_data.dart';
import 'package:permission_handler/permission_handler.dart';

class AddTaskScreen extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  AddTaskScreen({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  Recording _recording = Recording();
  bool _isRecording = false;
  String _recordingText = 'Start';
  String recordedAudioPath = '';
  String typedValue = '';

  Random random = new Random();
  TextEditingController _controller = new TextEditingController();

  _start() async {
    try {
      recordedAudioPath = '';
      if (await AudioRecorder.hasPermissions) {
//        if (_controller.text != null && _controller.text != "") {
//          String path = _controller.text;
        String path = '';

//        if (!_controller.text.contains('/')) {
        io.Directory appDocDirectory;
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }
        path = appDocDirectory.path +
            '/' +
            random.nextInt(2000).toString() +
            '-' +
            random.nextInt(2000).toString();

//          }
        print("Start recording: $path");
        await AudioRecorder.start(
            path: path, audioOutputFormat: AudioOutputFormat.AAC);
//        } else {
//          await AudioRecorder.start();
//        }
        bool isRecording = await AudioRecorder.isRecording;

        setState(() {
          _recording = new Recording(duration: new Duration(), path: "");
          _isRecording = isRecording;
          _recordingText = _isRecording ? 'Stop' : 'Start';
        });
      } else {
        print("Permission --------> You must accept permissions");
      }
    } catch (e) {
      print(e);
    }
  }

  _stop() async {
    try {
      var recording = await AudioRecorder.stop();
      print("Stop recording: ${recording.path}");
      bool isRecording = await AudioRecorder.isRecording;
      File file = widget.localFileSystem.file(recording.path);
      print("  File length: ${await file.length()}");
      setState(() {
        _recording = recording;
        _isRecording = isRecording;
        _recordingText = _isRecording ? 'Stop' : 'Start';
      });
      recordedAudioPath = recording.path;
      print(recording.path);
      print(recording.duration);
      print(recording.extension);
      print(recording.audioOutputFormat.toString());
    } catch (err) {
      print(err);
    }
  }

  Future<bool> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.storage,
    ].request();
    if (statuses[Permission.microphone].isGranted &&
        statuses[Permission.storage].isGranted) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
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
                print(value);
              },
              autofocus: true,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Enter title',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 20.0,
                ),
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
                fontSize: 20.0,
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
                String error = '';
                if (typedValue.isNotEmpty && typedValue != '') {
                  if (!_isRecording) {
                    Provider.of<TaskData>(context, listen: false).addTask(
                        typedValue.trim(),
                        recordedAudioPath,
                        _recording.extension);
                    Navigator.pop(context);
                  } else {
                    error = 'Stop the recording first';
                  }
                } else {
                  error = 'Enter the title';
                }

                if (error.isNotEmpty || error != '') {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    animType: AnimType.SCALE,
                    title: 'Error',
                    desc: error,
                    btnOkOnPress: () {},
                  )..show();
                }
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Record Audio',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w800,
                color: Colors.yellow.shade700,
              ),
            ),
            FlatButton(
              child: Text(
                '$_recordingText Recording',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
              color: Colors.yellow.shade700,
              onPressed: () async {
                if (!await requestPermissions()) {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.WARNING,
                    animType: AnimType.SCALE,
                    title: 'Warning',
                    desc: "Allow required permissions",
                    btnOkOnPress: () {},
                  )..show();
                  return;
                }

                _isRecording ? _stop() : _start();
              },
            ),
            Text(
              _isRecording ? 'Recording...' : 'PATH: $recordedAudioPath',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
