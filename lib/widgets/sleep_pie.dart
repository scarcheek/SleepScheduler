import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sleepscheduler/data/schedule.dart';

class SleepPie extends StatefulWidget {
  final Schedule schedule;

  SleepPie({Key? key, required this.schedule}) : super(key: key);

  @override
  _SleepPieState createState() => _SleepPieState(schedule);
}

class _SleepPieState extends State<SleepPie> {
  final double rotateBy =
      2 * pi / 1440; //the value the pie chart gets rotated by each tick
  late Schedule _schedule;

// the initial value of the rotation is set by the currenttime
  double rotation = -pi / 2 -
      (TimeOfDay.now().hour * 60 + TimeOfDay.now().minute) * 2 * pi / 1440;

  void handleTick(Timer t) {
    print(t);
    setState(() {
      rotation = rotation - t.tick * rotateBy;
      currentTime = currentTime.replacing(minute: currentTime.minute + 1);
    });
  }

  TimeOfDay currentTime = TimeOfDay.now();

  late Timer timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(minutes: 1), handleTick);
  }

  //constructor
  _SleepPieState(this._schedule);

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> pieData = [];

    double handledTimeInSeconds = 0;
    for (var sleep in _schedule.sleepCycles) {
      // Add the awake time between the last sleep and the current sleep
      pieData.add(PieChartSectionData(
          value: sleep.start - handledTimeInSeconds,
          color: Color(0xFF3F348B),
          radius: 80,
          showTitle: false));

      // Add the sleep itself
      pieData.add(PieChartSectionData(
          value: sleep.duration,
          color: Color(0xFF4949B1),
          radius: 80,
          showTitle: false));

      handledTimeInSeconds = sleep.start + sleep.duration;
    }

    if (handledTimeInSeconds < 24 * 60 /* minutes */) {
      pieData.add(PieChartSectionData(
          value: 24 * 60 /* minutes */ - handledTimeInSeconds,
          color: Color(0xFF3F348B),
          radius: 80,
          showTitle: false));
    }

    return Column(children: [
      Text(
        '${currentTime.hour}:${currentTime.minute}',
        style: TextStyle(color: Color(0xFF4949B1), fontSize: 20),
      ),
      Icon(
        Icons.arrow_drop_down,
        color: Color(0xFF4949B1),
      ),
      Container(
        height: 240,
        padding: EdgeInsets.only(bottom: 25),
        child: Transform.rotate(
          angle: rotation, // rotates the pie to start at the top
          child: PieChart(
            PieChartData(
                borderData: FlBorderData(
                  show: false,
                ),
                centerSpaceRadius: 30,
                sections: pieData,
                sectionsSpace: 3),
          ),
        ),
      ),
    ]);
  }
}
