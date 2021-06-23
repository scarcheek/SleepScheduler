import 'package:flutter/material.dart';
import 'package:sleepscheduler/data/schedule.dart';
import 'package:sleepscheduler/data/sleep.dart';
import 'package:sleepscheduler/widgets/snackbar_handler.dart';

import 'upcoming_sleep.dart';

class Upcoming extends StatefulWidget {
  final Schedule schedule;

  Upcoming({Key? key, required this.schedule}) : super(key: key);

  @override
  _UpcomingState createState() => _UpcomingState(schedule);
}

class _UpcomingState extends State<Upcoming> {
  late Schedule schedule;
  _UpcomingState(this.schedule);

  void onDelete(Sleep sleep) {
    SnackbarHandler().showSnackbar(
        context, 'Deleting ${sleep.startTime.toString()}', SnackbarType.info);
    schedule.remove(sleep);
  }

  void onEdit(Sleep sleep) {
    schedule.save();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Upcoming',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
      ]),
      Divider(
        endIndent: 10,
        indent: 10,
        thickness: 0.5,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(children: [
            ...schedule.sleepCycles
              .where((sleep) => sleep.start > TimeOfDay.now().hour * 60 + TimeOfDay.now().minute)
              .map((sleep) => UpcomingSleep(
                  key: Key(sleep.hashCode.toString()),
                  sleep: sleep,
                  onDelete: onDelete,
                  onEdit: onEdit,
              ))
          ]))
    ]);
  }
}
