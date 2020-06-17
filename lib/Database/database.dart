import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:todoeyflutter/Models/task.dart';

class DatabaseHelper {
  Future<Database> database;

  Future<void> openConnection() async {
    WidgetsFlutterBinding.ensureInitialized();
    database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'tasks_database.db'),
      // When the database is first created, create a table to store Tasks.
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE Task(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, isDone INTEGER)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<void> insertTask(Task task) async {
    // Get a reference to the database.
    final Database db = await database;

    // In this case, replace any previous data.
    await db.insert(
      'Task',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTask(Task task) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Task.
    await db.update(
      'Task',
      task.toMap(),
      // Ensure that the Task has a matching id.
      where: "id = ?",
      // Pass the Task's id as a whereArg to prevent SQL injection.
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Task from the Database.
    await db.delete(
      'Task',
      // Use a `where` clause to delete a specific Task.
      where: "id = ?",
      // Pass the Task's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<List<Task>> tasks() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Tasks.
    final List<Map<String, dynamic>> maps = await db.query('Task');

    // Convert the List<Map<String, dynamic> into a List<Task>.
    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        title: maps[i]['title'],
        isDone: Task.intTobool(maps[i]['isDone']),
      );
    });
  }
}
