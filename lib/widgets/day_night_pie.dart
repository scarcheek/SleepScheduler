import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sleepscheduler/data/schedule.dart';

class DayNightPie extends StatefulWidget {
  final double rotation;
  DayNightPie({Key? key, required this.rotation}) : super(key: key);

  @override
  _DayNightPieState createState() => _DayNightPieState(rotation);
}

final List<PieChartSectionData> debugData = [
  PieChartSectionData(
      value: 950, radius: 5, showTitle: false, color: Colors.amber[600]),
  PieChartSectionData(
      value: 490, radius: 5, showTitle: false, color: Colors.indigo[800]),
];

class _DayNightPieState extends State<DayNightPie> {
  double rotation = 0;

  _DayNightPieState(this.rotation);

  @override
  Widget build(BuildContext context) {
    double sunrise = 311;
    int minsPerDay = 24 * 60;
    double rotationPerMin = 360 / minsPerDay;

    return Container(
        height: 240,
        child: PieChart(PieChartData(
          borderData: FlBorderData(
            show: false,
          ),
          centerSpaceRadius: 30,
          sections: debugData,
          sectionsSpace: 2,
          startDegreeOffset: (rotation + sunrise * rotationPerMin) % 360,
        )));
  }
}
