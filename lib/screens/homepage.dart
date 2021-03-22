import 'package:flutter/material.dart';

import '../widgets.dart';

class Homepage extends StatefulWidget {
  
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
             Expanded(
               child: ListView(
                 children: [
                    Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 32,
                      top: 24,
                    ),
                    child: Image(
                      image: AssetImage("assets/images/logo.png"),
                    ),
                  ),

                  TaskCardWidget(
                    title: "Get Started",
                    desc: "Hello User! Welcome to TODO app, this is a default ask that you can edit or delete to start using this app."
                  ),
                  TaskCardWidget(),
                  TaskCardWidget(),
                  TaskCardWidget(),
                  TaskCardWidget(),
                  TaskCardWidget(),
                ],
              ),
                 ],
               ),
             ),
            Positioned(
              bottom: 24,
              right: 0,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFF7349FE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image(
                  image: AssetImage("assets/images/add_icon.png"),
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