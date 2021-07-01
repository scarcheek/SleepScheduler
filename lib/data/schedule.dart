import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sleepscheduler/data/sleep.dart';

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
    AndroidNotificationDetails(
        'Fcking Sleep Reminders', 'Fcking Sleep Reminders', 'Fcking Sleep Reminders',
        importance: Importance.max,
        priority: Priority.high,
        category: 'alarm',
        icon: 'app_icon',
        fullScreenIntent: true,
        showWhen: false);

    const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

    var minsPerDay = 1440;
    var currMinOfDay = TimeOfDay.now().hour * 60 + TimeOfDay.now().minute;
    var notifyTime = -30; /* notify 30min before sleep */

    var duration = Duration(minutes: ((sleep.start + minsPerDay - currMinOfDay + notifyTime) % minsPerDay).toInt());
    Timer(duration, () {
      flutterLocalNotificationsPlugin.show(
        Random().nextInt(6942069), sleep.name, 'Time to ${sleep.name}!\nDuration: ${sleep.duration}', platformChannelSpecifics,
        payload: 'i wars, ${sleep.name}');

      Timer.periodic(Duration(days: 1), (timer) {
        flutterLocalNotificationsPlugin.show(
        Random().nextInt(6942069), sleep.name, 'Time to ${sleep.name}!\nDuration: ${sleep.duration}', platformChannelSpecifics,
        payload: 'i wars wieder, ${sleep.name}');
      });
    });

    

    save();
  }

  void notify(Sleep sleep, platformChannelSpecifics) {
   
  }

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
