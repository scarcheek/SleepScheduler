import 'package:flutter/material.dart';
import 'package:sleepscheduler/data/schedule.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Padding(padding: EdgeInsets.symmetric(horizontal: 10), child:
          Text(
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
      ...schedule.sleepCycles.map((sleep) => UpcomingSleep(sleep: sleep))
    ]);
  }
}
