import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleepscheduler/data/schedule.dart';
import 'package:sleepscheduler/data/sharedpref.dart';
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
            bodyColor: Color(0xFF7A7AD3), displayColor: Color(0xFF7A7AD3)),
        iconTheme: IconThemeData(
          color: Color(0xFF7A7AD3),
        ),
        timePickerTheme: TimePickerThemeData(
            backgroundColor: Color(0xFF404082),
            dialHandColor: Color(0xFF3B3BCD),
            dayPeriodColor: Color(0xFF7A7AD3),
            hourMinuteColor: Color(0xFF7A7AD3),
            dayPeriodTextColor: Colors.black,
            hourMinuteTextColor: Colors.black,
            dialBackgroundColor: Color(0xFF7A7AD3),
            dayPeriodBorderSide: BorderSide(
              width: 0,
              color: Color(0xFF404082),
            ),
            helpTextStyle: TextStyle(color: Color(0xFF7A7AD3))),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Schedule _schedule = Schedule();

  @override
  void initState() {
    super.initState();
    initSchedule();
  }

  void initSchedule() async {
    Schedule newSchedule =
        Schedule.fromJson(await SharedPref().read('schedule'));
    _schedule.addAll(newSchedule.sleepCycles);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 40, right: 20, left: 20),
        child: Center(
          child: Column(
            children: <Widget>[
              ChangeNotifierProvider(
                create: (context) => _schedule,
                child: Home(),
                lazy: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
