import 'package:flutter/material.dart';
import 'package:flutter_todo_app_using_sqlit/constants/constans.dart';
import 'package:flutter_todo_app_using_sqlit/database_helper.dart';
import 'package:flutter_todo_app_using_sqlit/models/task.dart';
import 'package:flutter_todo_app_using_sqlit/models/todo.dart';

import '../widgets.dart';

class Taskpage extends StatefulWidget {
  final Task task;
  Taskpage({@required this.task});
  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  DatabaseHelper _dbHelper = new DatabaseHelper();

  String _todoItem;

  int _taskId = 0;
  String _taskTitle = "";
  String _taskDescription = "";
  String _todoText = "";

  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _todoFocus;

  bool _contentVisible = false;

  @override
  void initState() {
    if (widget.task != null) {
      // set visibility to true

      _contentVisible = true;
      _taskTitle = widget.task.title;
      _taskDescription = widget.task.description;
      _taskId = widget.task.id;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24,
                      bottom: 6,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(25),
                          onTap: () async {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Image(
                              image: AssetImage(
                                  "assets/images/back_arrow_icon.png"),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: _titleFocus,
                            controller: TextEditingController()
                              ..text = _taskTitle,
                            onSubmitted: (value) async {
                              if (value != "") {
                                if (widget.task == null) {
                                  Task _newTask = Task(title: value);
                                  _taskId =
                                      await _dbHelper.insertTask(_newTask);

                                  setState(() {
                                    _contentVisible = true;
                                    _taskTitle = value;
                                  });

                                  print(_taskId);
                                } else {
                                  if (_taskId != 0) {
                                    await _dbHelper.updateTaskTitle(
                                        _taskId, value);
                                  }
                                }
                              }
                              _descriptionFocus.requestFocus();
                            },
                            decoration: InputDecoration(
                              hintText: "Enter Task Title",
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF211551),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12.0,
                      ),
                      child: TextField(
                        controller: TextEditingController()
                          ..text = _taskDescription,
                        focusNode: _descriptionFocus,
                        onSubmitted: (value) async {
                          if (value != "") {
                            if (_taskId != 0) {
                              await _dbHelper.updateTaskDescription(
                                  _taskId, value);
                              _taskDescription = value;
                            }
                          }
                          _todoFocus.requestFocus();
                        },
                        decoration: InputDecoration(
                          hintText: "Enter Description for the task...",
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 24),
                        ),
                      ),
                    ),
                  ),

                  // Todo list view
                  Visibility(
                    visible: _contentVisible,
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTodo(_taskId),
                      builder: (context, snapshot) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  // Switching the todo completation state
                                  if (snapshot.data[index].isDone == 0) {
                                    await _dbHelper.updateTodoDone(
                                        snapshot.data[index].id, 1);
                                  } else {
                                    await _dbHelper.updateTodoDone(
                                        snapshot.data[index].id, 0);
                                  }

                                  setState(() {});
                                },
                                child: TodoWidget(
                                  text: snapshot.data[index].title,
                                  isDone: snapshot.data[index].isDone == 0
                                      ? false
                                      : true,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  // End of Todo list view

                  Column(
                    children: [
                      Visibility(
                        visible: _contentVisible,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 12),
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: borderColor,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  focusNode: _todoFocus,
                                  controller: TextEditingController()
                                    ..text = _todoText,
                                  onSubmitted: (value) {
                                    if (_todoItem != "") {
                                      if (_taskId != 0) {
                                        Todo _newTodo = Todo(
                                          title: _todoItem,
                                          isDone: 0,
                                          taskId: _taskId,
                                        );
                                        _dbHelper.insertTodo(_newTodo);
                                        // print("Added Todo...................");
                                        setState(() {});
                                        _todoFocus.requestFocus();
                                      } else {
                                        print("something went wrong");
                                      }
                                    }
                                  },
                                  onChanged: (value) {
                                    _todoItem = value;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Create todo items...",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Visibility(
                visible: _contentVisible,
                child: Positioned(
                  bottom: 24,
                  right: 24,
                  child: GestureDetector(
                    onTap: () async {
                      if (_taskId != 0) {
                        await _dbHelper.deleteTask(_taskId);

                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Image(
                        image: AssetImage("assets/images/delete_icon.png"),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
