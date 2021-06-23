import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleepscheduler/data/schedule.dart';
import 'package:sleepscheduler/data/sleep.dart';
import 'package:sleepscheduler/widgets/date_time_header.dart';
import 'package:sleepscheduler/widgets/sleep_pie.dart';
import 'package:sleepscheduler/widgets/snackbar_handler.dart';
import 'package:sleepscheduler/widgets/upcoming.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _createNewSector(BuildContext context, Schedule schedule) async {
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

    // Checks whether the new sleep overlaps with any preexisting sleeps
    Sleep sleep = Sleep(startTime, duration);
    if (schedule.sleepCycles.any((element) {
      if (element.start == sleep.start) return true;

      if ((element.start + element.duration) % 1440 > sleep.start &&
          element.start < sleep.start) return true;

      if ((sleep.start + sleep.duration) % 1440 > element.start &&
          sleep.start < element.start) return true;

      return false;
    }))
      return SnackbarHandler().showSnackbar(
          context,
          'You are not allowed to sleep at that time',
          SnackbarType.error);

    schedule.add(sleep);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Schedule>(
      builder: (context, schedule, child) => Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            IconButton(
                onPressed: () {
                  _createNewSector(context, schedule);
                },
                icon: Icon(Icons.add),
                splashRadius: 20,
                color: Theme.of(context).colorScheme.primary),
          ]),
          DateTimeHeader(),
          SleepPie(schedule: schedule),
          Upcoming(schedule: schedule),
        ],
      ),
    );
  }
}
