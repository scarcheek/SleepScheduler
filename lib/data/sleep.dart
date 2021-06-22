import 'package:flutter/material.dart';

class Sleep {
  late double start;

  late double duration;

  Sleep(TimeOfDay start, TimeOfDay duration) {
    this.start = (start.hour * 60 + start.minute).toDouble();
    this.duration = (duration.hour * 60 + duration.minute).toDouble();
  }
}
