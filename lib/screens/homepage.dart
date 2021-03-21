import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                  child: FutureBuilder(builder: (context, snapshot) {
                    return ScrollConfiguration(
                      // behavior: NoGlowBehaviour(),
                      child: ListView.builder(
                        itemCount: 50,
                        itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){},

                          child: Text("Hello"),
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
