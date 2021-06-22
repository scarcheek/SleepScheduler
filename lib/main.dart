import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Container(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
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
