import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleepscheduler/data/schedule.dart';
import 'package:sleepscheduler/pages/home.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Sleep Scheduler',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFF2F1354),
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Color(0xFF7A7AD3), 
          displayColor: Color(0xFF7A7AD3)
        ),
        iconTheme: IconThemeData(
          color: Color(0xFF7A7AD3),
        ),
      ),
      home: Scaffold(
        body: Container(
          margin: EdgeInsets.only(top: 40, right: 20, left: 20),
            child: ChangeNotifierProvider(
              create: (context) => Schedule(),
              child: Home(),
            ),
        ),
      ),
    );
  }
}
