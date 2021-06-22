import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sleepscheduler/data/schedule.dart';
import 'package:sleepscheduler/data/sleep.dart';

class SleepPie extends StatefulWidget {
  @override
  _SleepPieState createState() => _SleepPieState(schedule);

  SleepPie({Key? key, required this.schedule}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final Schedule schedule;
}

class _SleepPieState extends State<SleepPie> {
  late Schedule _schedule;

  _SleepPieState(Schedule schedule) {
    _schedule = schedule;
  }
  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> pieChartDataSet = [];

    double currTime = 0;
    for (var i = 0; i < _schedule.sleepCycles.length; i++) {
      //Wakey
      pieChartDataSet.add(PieChartSectionData(
          value: _schedule.sleepCycles[i].start - currTime,
          color: Color(0xFF3F348B),
          radius: 80,
          showTitle: false));
      //Sleep
      pieChartDataSet.add(PieChartSectionData(
          value: _schedule.sleepCycles[i].duration,
          color: Color(0xFF4949B1),
          radius: 80,
          showTitle: false));

      currTime =
          _schedule.sleepCycles[i].start + _schedule.sleepCycles[i].duration;
    }

    if (currTime < 1440) {
      pieChartDataSet.add(PieChartSectionData(
          value: 1440 - currTime,
          color: Color(0xFF3F348B),
          radius: 80,
          showTitle: false));
    }

    return Transform.rotate(
      angle: -pi / 2,
      child: Container(
        height: 260,
        child: PieChart(
          PieChartData(
              borderData: FlBorderData(
                show: false,
              ),
              centerSpaceRadius: 30,
              sections: pieChartDataSet,
              sectionsSpace: 5),
        ),
      ),
    );
  }
}
