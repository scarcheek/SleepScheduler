import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:sleepscheduler/data/sleep.dart';

class Schedule extends ChangeNotifier {
  final List<Sleep> _sleepCycles = [];

  UnmodifiableListView<Sleep> get sleepCycles =>
      UnmodifiableListView(_sleepCycles);

  void add(Sleep sleep) {
    _sleepCycles.add(sleep);
    _sleepCycles.sort((a, b) => ((a.start) - (b.start)).toInt());

    notifyListeners();
  }
}
