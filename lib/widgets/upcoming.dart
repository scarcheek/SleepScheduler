import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sleepscheduler/data/schedule.dart';

import '../main.dart';
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Upcoming',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        IconButton(onPressed: () async {
          const AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
                'your channel id', 'your channel name', 'your channel description',
                importance: Importance.max,
                priority: Priority.high,
                category: 'alarm',
                icon: 'app_icon',
                fullScreenIntent: true,
                showWhen: false);

          const NotificationDetails platformChannelSpecifics =
              NotificationDetails(android: androidPlatformChannelSpecifics);

          Timer(Duration(seconds: 5), () {
            flutterLocalNotificationsPlugin.show(
              0, 'plain title', 'plain body', platformChannelSpecifics,
              payload: 'item x');
          });
        }, icon: Icon(Icons.access_alarm))
      ]),
      Divider(
        endIndent: 10,
        indent: 10,
        thickness: 0.5,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListView(shrinkWrap: true, children: <Widget>[
          ...schedule.sleepCycles
              .where((sleep) =>
                  sleep.start >
                  TimeOfDay.now().hour * 60 + TimeOfDay.now().minute)
              .map((sleep) => UpcomingSleep(
                    key: Key(sleep.hashCode.toString()),
                    sleep: sleep,
                    schedule: schedule,
                  )),
          ...schedule.sleepCycles
              .where((sleep) =>
                  sleep.start <=
                  TimeOfDay.now().hour * 60 + TimeOfDay.now().minute)
              .map((sleep) => UpcomingSleep(
                    key: Key(sleep.hashCode.toString()),
                    sleep: sleep,
                    schedule: schedule,
                  )),
        ]),
      ),
    ]);
  }
}
