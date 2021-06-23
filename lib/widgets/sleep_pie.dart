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
  static int minsPerDay = 24 * 60;
  static double rotationPerMin = 360 / minsPerDay;

  late Schedule _schedule;
  double rotation = 0;

  void handleTimeChange(Timer t) {
    setState(() {
      currentTime = TimeOfDay.now();
    });
  }

  void handleTurn(Timer t) {
    setState(() {
      rotation = (360 + rotation - rotationPerMin) % 360;
    });
  }

  TimeOfDay currentTime = TimeOfDay.now();

  late Timer turnTimer;
  late Timer timeTimer;
  @override
  void initState() {
    super.initState();
    turnTimer = Timer.periodic(Duration(minutes: 1), handleTurn);
    timeTimer = Timer.periodic(Duration(seconds: 1), handleTimeChange);
  }

  //constructor
  _SleepPieState(this._schedule);

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> pieSectors = [];

    double accSectorTime = 0;
    double firstSleepRotationOffset = 0;
    for (var idx = 0; idx < _schedule.sleepCycles.length; idx++) {
      var sleep = _schedule.sleepCycles[idx];

      // not the first sleep
      if (idx > 0) {
        // add the awake time between the current and the previous sleep
        pieSectors.add(PieChartSectionData(
          value: sleep.start - accSectorTime,
          color: Theme.of(context).colorScheme.secondary,
          radius: 60,
          showTitle: false,
        ));
      }

      // add the sleep
      pieSectors.add(PieChartSectionData(
        value: sleep.duration,
        color: Theme.of(context).colorScheme.secondaryVariant,
        radius: 80,
        showTitle: false,
      ));

      accSectorTime = sleep.start + sleep.duration;
    }

    var firstSleepStart =
        (_schedule.sleepCycles.length > 0) ? _schedule.sleepCycles[0].start : 0;

    if (accSectorTime < 24 * 60 /* minutes */ || firstSleepStart != 0) {
      // add the awake time between the last and the first sleep
      pieSectors.add(PieChartSectionData(
        value: 24 * 60 /* minutes */ - accSectorTime + firstSleepStart,
        color: Theme.of(context).colorScheme.secondary,
        radius: 60,
        showTitle: false,
      ));

      firstSleepRotationOffset = firstSleepStart * rotationPerMin;
    }

    rotation = 270; // rotates the pie to have 00:00 at the top
    rotation += firstSleepRotationOffset % 360;
    // rotate to the current time
    rotation = (360 +
            rotation -
            (TimeOfDay.now().hour * 60 + TimeOfDay.now().minute) *
                rotationPerMin) %
        360;

    return Column(children: [
      Stack(
        alignment: Alignment.topCenter,
        children: [
          Text(
            currentTime.toString().split(RegExp('[()]'))[1],
            style: Theme.of(context).textTheme.headline3,
          ),
          Padding(
            padding: EdgeInsets.only(
                top: Theme.of(context).textTheme.headline3!.fontSize! * 0.75),
            child: Icon(
              Icons.arrow_drop_down,
              size: 28,
            ),
          ),
        ],
      ),
      Container(
        height: 250,
        padding: EdgeInsets.only(bottom: 25),
        child: PieChart(
          PieChartData(
            borderData: FlBorderData(
              show: false,
            ),
            centerSpaceRadius: 30,
            sections: pieSectors,
            sectionsSpace: 2,
            startDegreeOffset: rotation,
          ),
        ),
      ),
    ]);
  }
}
