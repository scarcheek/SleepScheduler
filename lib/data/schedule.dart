import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:isolate';
import 'dart:math';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sleepscheduler/data/sleep.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';
import 'sharedpref.dart';

class Schedule extends ChangeNotifier {
  List<Sleep> _sleepCycles = [];

  Schedule();

  UnmodifiableListView<Sleep> get sleepCycles =>
      UnmodifiableListView(_sleepCycles);

  void add(Sleep sleep) {
    _sleepCycles.add(sleep);
    _sleepCycles.sort((a, b) => (a.start - b.start).toInt());

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('Fcking Sleep Reminders',
            'Fcking Sleep Reminders', 'Fcking Sleep Reminders',
            importance: Importance.max,
            priority: Priority.high,
            category: 'alarm',
            icon: 'app_icon',
            // fullScreenIntent: true,
            showWhen: false);

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Isolate.spawn((message) async {
    var minsPerDay = 1440;
    var currMinOfDay = TimeOfDay.now().hour * 60 + TimeOfDay.now().minute;
    var notifyTime = -30; /* notify 30min before sleep */

    var duration = Duration(
        minutes: ((sleep.start + minsPerDay - currMinOfDay + notifyTime) %
                minsPerDay)
            .toInt());

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Europe/Vienna"));

//TODO(rami-a): Tua des mit da duration und den restlichen scheiss bitte danke :-)
    print("Doing da notification shit");
    flutterLocalNotificationsPlugin
        .zonedSchedule(
            Random().nextInt(6942069),
            sleep.name,
            'Time to ${sleep.name}!\nDuration: ${sleep.duration}',
            tz.TZDateTime.now(tz.local).add(Duration(seconds: 10)),
            platformChannelSpecifics,
            payload: 'i wars, ${sleep.name}',
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime)
        .whenComplete(() => flutterLocalNotificationsPlugin.periodicallyShow(
            Random().nextInt(6942069),
            sleep.name,
            'Time to ${sleep.name}!\nDuration: ${sleep.duration}',
            RepeatInterval.everyMinute,
            platformChannelSpecifics,
            payload: 'i wars, ${sleep.name}'));

    print("FERTIIIIG");
    save();
  }

  void notify(Sleep sleep, platformChannelSpecifics) {}

  void addAll(List<Sleep> sleepCycles) {
    _sleepCycles.addAll(sleepCycles);
    save();
  }

  void remove(Sleep sleep) {
    _sleepCycles.remove(sleep);
    save();
  }

  void save() {
    SharedPref().save('schedule', this);
    notifyListeners();
  }

  Schedule.fromJson(Map<String, dynamic> json)
      : _sleepCycles = (jsonDecode(json['sleepcycles']) as List)
            .map((e) => Sleep.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() => {'sleepcycles': jsonEncode(_sleepCycles)};
}
