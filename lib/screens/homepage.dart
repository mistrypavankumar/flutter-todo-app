import 'package:flutter/material.dart';
import 'package:flutter_todo_app_using_sqlit/database_helper.dart';

import '../widget.dart';
import 'taskpage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24),
        color: Color(0xFFF6F6F6),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 32,
                    bottom: 32,
                  ),
                  child: Image(
                    image: AssetImage('assets/images/logo.png'),
                  ),
                ),
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TaskPage(
                                                task: snapshot.data[index],
                                              )),
                                    ).then((value) {
                                      setState(() {});
                                    });
                                  },
                                  child: TaskCardWidget(
                                    title: snapshot.data[index].title,
                                    desc: snapshot.data[index].description,
                                  ),
                                );
                              }),
                        );
                      }),
                )
              ],
            ),
          ],
        ),
      )),
    );
  }
}
