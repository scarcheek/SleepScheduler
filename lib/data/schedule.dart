import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:sleepscheduler/data/sleep.dart';

class Schedule extends ChangeNotifier {
  List<Sleep> _sleepCycles = [];

  Schedule();

  UnmodifiableListView<Sleep> get sleepCycles =>
      UnmodifiableListView(_sleepCycles);

  void add(Sleep sleep) {
    if (_sleepCycles.any((element) {
      if (element.start == sleep.start) return true;

      if ((element.start + element.duration) % 1440 > sleep.start &&
          element.start < sleep.start) return true;

      if ((sleep.start + sleep.duration) % 1440 > element.start &&
          sleep.start < element.start) return true;

      return false;
    })) return; //TODO: Rückmeldung
    _sleepCycles.add(sleep);
    _sleepCycles.sort((a, b) => (a.start - b.start).toInt());

    notifyListeners();
  }

  void addAll(List<Sleep> sleepCycles) {
    _sleepCycles.addAll(sleepCycles);
    notifyListeners();
  }

  Schedule.fromJson(Map<String, dynamic> json)
      : _sleepCycles = (jsonDecode(json['sleepcycles']) as List)
            .map((e) => Sleep.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() => {'sleepcycles': jsonEncode(_sleepCycles)};
}
