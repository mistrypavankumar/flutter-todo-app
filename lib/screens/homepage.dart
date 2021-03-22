import 'package:flutter/material.dart';
import 'package:flutter_todo_app_using_sqlit/constants/constans.dart';
import 'package:flutter_todo_app_using_sqlit/database_helper.dart';
import 'package:flutter_todo_app_using_sqlit/screens/taskpage.dart';

import '../widgets.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DatabaseHelper _dbHelper = new DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          color: Color(0xFFF6F6F6),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //logo container
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 32,
                      top: 24,
                    ),
                    child: Image(
                      image: AssetImage("assets/images/logo.png"),
                    ),
                  ),

                  // List of tasks
                  Expanded(
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTasks(),
                      builder: (context, snapshot) {
                        return ScrollConfiguration(
                          behavior: NoGlowBehaviour(),
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => Taskpage(
                                      task: snapshot.data[index],
                                    )))
                                .then((value) => setState(() {}));
                                },
                                child: TaskCardWidget(
                                  title: snapshot.data[index].title,
                                  desc: snapshot.data[index].description,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 24,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Taskpage(
                              task: null,
                            )))
                        .then((value) => setState(() {}));
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryLightColor, primaryColor],
                        begin: Alignment(0, -1),
                        end: Alignment(0, 1),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image(
                      image: AssetImage("assets/images/add_icon.png"),
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
