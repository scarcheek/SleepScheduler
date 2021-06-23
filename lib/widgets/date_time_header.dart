import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DateTimeHeader extends StatefulWidget {
  @override
  _DateTimeHeaderState createState() => _DateTimeHeaderState();
}

class _DateTimeHeaderState extends State<DateTimeHeader> {
  TimeOfDay _currTime = TimeOfDay.now();
  DateTime _currDate = DateTime.now();
  
  _DateTimeHeaderState() {
    Timer.periodic(Duration(seconds: 10), (timer) => setState(() {
      _currTime = TimeOfDay.now();
      _currDate = DateTime.now();
    }));
  }

  @override
  Widget build(BuildContext context) {
    String timeName = 'It\'s a special time';
    
    if (_currTime.hour >= 6 && _currTime.hour < 12) {
      timeName = 'Morning';
    }
    else if (_currTime.hour >= 12 && _currTime.hour < 18) {
      timeName = 'Afternoon';
    }
    else if (_currTime.hour >= 18 && _currTime.hour < 23) {
      timeName = 'Evening';
    }
    else {
      timeName = 'Night';
    }

    return IntrinsicHeight(
      child: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: -pi/2, 
              child: Text(_currDate.day.toString(), style: Theme.of(context).textTheme.headline4),
            ),
            VerticalDivider(
              color: Theme.of(context).colorScheme.onPrimary,
              thickness: 2, 
              width: 3,
              indent: 4,
              endIndent: 4,
            ),
            Padding(
              padding: EdgeInsets.only(left: 4),
              child: Text(timeName.toUpperCase(), style: Theme.of(context).textTheme.headline1),
            ),
          ],
        ),
      ),
    );
  }
}
