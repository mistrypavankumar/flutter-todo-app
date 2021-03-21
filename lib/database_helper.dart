import 'dart:core';

import "package:path/path.dart";
import 'package:sqflite/sqflite.dart';

import 'models/task.dart';
import 'models/todo.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) async {
        // creating database table with name task
        await db.execute("""CREATE TABLE tasks(
            id INTEGER PRIMARY KEY,
            title TEXT,
            description TEXT
          )""");

        // creating database table with name todo
        await db.execute("""CREATE TABLE todo(
            id INTEGER PRIMARY KEY,
            taskId INTEGET
            title TEXT,
            isDone INTEGER
          
          )""");

        return db;
      },
      version: 1,
    );
  }

  // future function for insertion of task
  Future<int> insertTask(Task task) async {
    int taskId = 0;

    Database _db = await database();

    //inserting data into database with table name task
    await _db
        .insert('task', task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) => {taskId = value});
    return taskId;
  }

  // Future function for updating task title
  Future<void> updateTaskTitle(int id, String title) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET title = `$title` WHERE id = `$id`");
  }

  // Future function for updating description
  Future<void> updateTaskDescription(int id, String description) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET description = `$description` WHERE id = `$id`");
  }

  // Future function for inserting todo
  Future<void> insertTodo(Todo todo) async{
    Database _db = await database();
    await _db.insert('todo', todo.toMap(), 
    conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Future function for getting tasks
  Future<List<Task>> getTasks() async{
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');
    return List.generate(taskMap.length,(index){
        return Task(id: taskMap[index]['id'],
        title: taskMap[index]['title'],
        description: taskMap[index]['description']);
    });
  }

  // Future function for getting todo's
  Future<List<Todo>> getTodo(int taskId) async{
    Database _db = await database();
    List<Map<String, dynamic>> todoMap = await _db.rawQuery("""
      SELECT * FROM todo WHERE taskId = `$taskId`
    """);

    return List.generate(todoMap.length,(index){
        return Task(id: todoMap[index]['id'],
        title: todoMap[index]['title'],
        description: todoMap[index]['taskId'],
        isDone: todoMap[index]['isDone']
        );
    });
  }

  // Future function for updating todo's 
  Future<void> updateTodoDone(int id, int isDone) async{
    Database _db = await database();
    await _db.rawUpdate("UPDATE todo SET isDone = `$isDone` WHERE id = `$id`");
  }

  // Future function for deleting task
  Future<void> deleteTask(int id) async{
        Database _db = await database();
    await _db.rawDelete("DELETE FROM tasks WHERE id = `$id`");
    await _db.rawDelete("DELETE FROM todo WHERE id = `$id`");
  }


}
