import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sleepscheduler/data/schedule.dart';
import 'package:sleepscheduler/data/sharedpref.dart';
import 'package:sleepscheduler/pages/home.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          onDidReceiveLocalNotification: (a,b,c,d) async {}); // TODO(rami-a): learn what this alphabet does

  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS);
      
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (payload) async {}); // TODO(rami-a): learn what this alphabet does

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
            error: Colors.red[400]!,
            onPrimary: Colors.blueGrey[700]!,
            onSecondary: Color(0xFF323367),
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
                headline2: TextStyle(fontSize: 28),
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
          color: Colors.blueGrey[700],
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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        minimum: EdgeInsets.only(top: 20, right: 20, left: 20),
        child: ChangeNotifierProvider(
          create: (context) => _schedule,
          child: Home(),
          lazy: true,
        )
      ),
    );
  }
}
