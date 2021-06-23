import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleepscheduler/data/schedule.dart';
import 'package:sleepscheduler/data/sharedpref.dart';
import 'package:sleepscheduler/data/sleep.dart';
import 'package:sleepscheduler/widgets/date_time_header.dart';
import 'package:sleepscheduler/widgets/sleep_pie.dart';

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
      helpText: "Select Duration".toUpperCase(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    //TODO: moch a rückmeldung oder so
    if (duration == null || duration.hour * 60 + duration.minute <= 0)
      return /* action canceled */;

    schedule.add(Sleep(startTime, duration));

    SharedPref().save('schedule', schedule);
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
            ),
          ]),
          DateTimeHeader(),
          SleepPie(schedule: schedule),
          Text(
            'You have pushed the button too many times:',
          ),
          Text(
            'You broke the counter >:/',
            style: Theme.of(context).textTheme.headline5,
          ),
          Divider(
            endIndent: 10,
            indent: 10,
            thickness: 0.5,
            color: Color(0xFF5757a1),
          ),
        ],
      ),
    );
  }
}
