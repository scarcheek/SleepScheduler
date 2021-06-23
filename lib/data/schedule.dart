import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:sleepscheduler/data/sleep.dart';
import 'package:sleepscheduler/widgets/snackbar_handler.dart';

class Schedule extends ChangeNotifier {
  List<Sleep> _sleepCycles = [];

  Schedule();

  UnmodifiableListView<Sleep> get sleepCycles =>
      UnmodifiableListView(_sleepCycles);

  void add(Sleep sleep) {
    _sleepCycles.add(sleep);
    _sleepCycles.sort((a, b) => (a.start - b.start).toInt());

    notifyListeners();
  }

  void addAll(List<Sleep> sleepCycles) {
    _sleepCycles.addAll(sleepCycles);
    notifyListeners();
  }

  void remove(Sleep sleep) {
    _sleepCycles.remove(sleep);
    notifyListeners();
  }

  Schedule.fromJson(Map<String, dynamic> json)
      : _sleepCycles = (jsonDecode(json['sleepcycles']) as List)
            .map((e) => Sleep.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() => {'sleepcycles': jsonEncode(_sleepCycles)};
}
