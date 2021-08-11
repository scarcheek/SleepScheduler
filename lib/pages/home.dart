import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleepscheduler/data/schedule.dart';
import 'package:sleepscheduler/widgets/date_time_header.dart';
import 'package:sleepscheduler/widgets/sleep_pie.dart';
import 'package:sleepscheduler/widgets/upcoming.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Schedule>(
      builder: (context, schedule, child) => 
        // SingleChildScrollView(child: 
          Column(
            children: [
              DateTimeHeader(),
              SleepPie(schedule: schedule),
              Upcoming(schedule: schedule),
            ],
          ),
        // ),      
    );
  }
}
