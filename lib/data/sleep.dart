import 'dart:convert';
import 'package:flutter/material.dart';

class Sleep {
  late double start;
  late double duration;
  late TimeOfDay startTime;

  Sleep(TimeOfDay start, TimeOfDay duration) {
    this.start = (start.hour * 60 + start.minute).toDouble();
    this.duration = (duration.hour * 60 + duration.minute).toDouble();
    this.startTime = start;
  }

  Sleep.fromJson(Map<String, dynamic> json)
      : start = json['start'],
        duration = json['duration'],
        startTime = TimeOfDay(
            hour: (json['start'] / 60).floor(),
            minute: (json['start'].toInt() % 60));

  Map<String, dynamic> toJson() => {'start': start, 'duration': duration};
}
