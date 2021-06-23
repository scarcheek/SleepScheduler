import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xff201f47),
        colorScheme: ColorScheme(
            primary: Colors.green[300]!,
            primaryVariant: Colors.green[600]!,
            secondary: Colors.indigo[600]!,
            secondaryVariant: Colors.deepPurple[800]!,
            surface: Color(0xff201f47),
            background: Color(0xff201f47),
            error: Color(0xFF400000),
            onPrimary: Colors.blueGrey[700]!,
            onSecondary: Colors.deepPurple[300]!,
            onSurface: Colors.indigo[400]!,
            onBackground: Colors.indigo[400]!,
            onError: Colors.red[50]!,
            brightness: Brightness.dark),
        textTheme: Theme.of(context)
            .textTheme
            .apply(
              fontFamily: GoogleFonts.nunito().fontFamily,
              displayColor: Colors.indigo[300],
              bodyColor: Colors.indigo,
            )
            .merge(TextTheme(
                headline1: TextStyle(fontSize: 32, letterSpacing: 0.5),
                headline3: GoogleFonts.montserrat(
                  fontSize: 24,
                  color: Colors.green[300],
                ),
                headline4: GoogleFonts.montserrat(
                  fontSize: 21,
                  color: Colors.deepPurple[400],
                  fontWeight: FontWeight.w300,
                ))),
        iconTheme: IconThemeData(
          color: Colors.green[300],
        ),
        timePickerTheme: TimePickerThemeData(
            helpTextStyle: TextStyle(color: Colors.indigo[300])),
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
