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
  late Schedule _schedule;
  _SleepPieState(this._schedule);

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> pieData = [];

    double currTime = 0;
    for (var sleep in _schedule.sleepCycles) {
      // Add the awake time between the last sleep and the current sleep
      pieData.add(PieChartSectionData(
        value: sleep.start - currTime,
        color: Color(0xFF3F348B),
        radius: 80,
        showTitle: false
      ));

      // Add the sleep itself
      pieData.add(PieChartSectionData(
        value: sleep.duration,
        color: Color(0xFF4949B1),
        radius: 80,
        showTitle: false
      ));

      currTime = sleep.start + sleep.duration;
    }

    if (currTime < 24*60 /* minutes */) {
      pieData.add(PieChartSectionData(
        value: 24*60 /* minutes */ - currTime,
        color: Color(0xFF3F348B),
        radius: 80,
        showTitle: false
      ));
    }

    return Transform.rotate(
      angle: -pi / 2, // rotates the pie to start at the top
      child: Container(
        height: 260,
        child: PieChart(
          PieChartData(
            borderData: FlBorderData(
              show: false,
            ),
            centerSpaceRadius: 30,
            sections: pieData,
            sectionsSpace: 3
          ),
        ),
      ),
    );
  }
}
