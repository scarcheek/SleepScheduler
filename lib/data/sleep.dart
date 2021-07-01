import 'package:flutter/material.dart';

class Sleep {
  late double start;
  late double duration;
  late TimeOfDay startTime;
  late String name;
  late int notifId;

  Sleep(TimeOfDay start, TimeOfDay duration, String name) {
    this.start = (start.hour * 60 + start.minute).toDouble();
    this.duration = (duration.hour * 60 + duration.minute).toDouble();
    this.startTime = start;
    this.name = name;
  }

  Sleep.fromJson(Map<String, dynamic> json)
      : start = json['start'],
        duration = json['duration'],
        startTime = TimeOfDay(
            hour: (json['start'] / 60).floor(),
            minute: (json['start'].toInt() % 60)),
        name = json['name'],
        notifId = json['notifid'];

  Map<String, dynamic> toJson() =>
      {'start': start, 'duration': duration, 'name': name, 'notifid': notifId};
}
