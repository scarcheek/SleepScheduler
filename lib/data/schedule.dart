import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:sleepscheduler/data/sleep.dart';

import 'sharedpref.dart';

class Schedule extends ChangeNotifier {
  List<Sleep> _sleepCycles = [];
  Sleep? focusedSleep;

  Schedule();

  UnmodifiableListView<Sleep> get sleepCycles =>
      UnmodifiableListView(_sleepCycles);

  void add(Sleep sleep) {
    _sleepCycles.add(sleep);
    _sleepCycles.sort((a, b) => (a.start - b.start).toInt());

    save();
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

  void focus(Sleep? sleep) {
    focusedSleep = sleep;
    notifyListeners();
  }

  Schedule.fromJson(Map<String, dynamic> json)
      : _sleepCycles = (jsonDecode(json['sleepcycles']) as List)
            .map((e) => Sleep.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() => {'sleepcycles': jsonEncode(_sleepCycles)};
}
