import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sleepscheduler/data/schedule.dart';
import 'package:sleepscheduler/data/sleep.dart';
import 'package:sleepscheduler/widgets/day_night_pie.dart';
import 'package:sleepscheduler/widgets/snackbar_handler.dart';
import 'package:sleepscheduler/widgets/text_dialog.dart';

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
    setState(() {});
  }

  TimeOfDay currentTime = TimeOfDay.now();

  late Timer turnTimer;
  late Timer timeTimer;
  @override
  void initState() {
    super.initState();
    turnTimer = Timer.periodic(Duration(seconds: 1), handleTurn);
    timeTimer = Timer.periodic(Duration(seconds: 1), handleTimeChange);
  }

  //constructor
  _SleepPieState(this._schedule);

  void addSleep(BuildContext context, Schedule schedule) async {
    TimeOfDay? startTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now().replacing(minute: 30),
    );

    if (startTime == null) return /* action canceled */;

    TimeOfDay? duration = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 0, minute: 0),
      initialEntryMode: TimePickerEntryMode.input,
      helpText: 'Select Duration'.toUpperCase(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (duration == null) return /* action canceled */;

    if (duration.hour * 60 + duration.minute <= 0)
      return SnackbarHandler().showSnackbar(
          context,
          'Scheduling a sleep with a duration of 0 doesn\'t make any sense.',
          SnackbarType.error);

    String? name =
        await TextDialog.show(context, 'Enter Name'.toUpperCase(), 'Sleep');

    if (name == null) name = 'Sleep'; /* action canceled */

    // Checks whether the new sleep overlaps with any preexisting sleeps
    Sleep sleep = Sleep(startTime, duration, name);
    if (schedule.sleepCycles.any((element) {
      if (element.start == sleep.start) return true;

      if ((element.start + element.duration) % 1440 > sleep.start &&
          element.start < sleep.start) return true;

      if ((sleep.start + sleep.duration) % 1440 > element.start &&
          sleep.start < element.start) return true;

      return false;
    }))
      return SnackbarHandler().showSnackbar(context,
          'You are not allowed to sleep at that time', SnackbarType.error);

    schedule.add(sleep);
  }

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
          radius: 70,
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
        radius: 70,
        showTitle: false,
      ));

      firstSleepRotationOffset = firstSleepStart * rotationPerMin;
    }

    rotation = 270; // rotates the pie to have 00:00 at the top
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
      Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 240,
            child: PieChart(PieChartData(
              borderData: FlBorderData(
                show: false,
              ),
              centerSpaceRadius: 37,
              sections: pieSectors,
              sectionsSpace: 2,
              startDegreeOffset: (rotation + firstSleepRotationOffset) % 360,
            )),
          ),
          DayNightPie(
            rotation: rotation,
          ),
          IconButton(
              onPressed: () {
                addSleep(context, this._schedule);
              },
              iconSize: 30,
              icon: Icon(Icons.add),
              splashRadius: 30,
              color: Theme.of(context).colorScheme.primary),
        ],
      ),
    ]);
  }
}
