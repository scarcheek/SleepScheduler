import 'package:flutter/material.dart';
import 'package:sleepscheduler/data/sleep.dart';

class UpcomingSleep extends StatefulWidget {
  final Sleep sleep;

  UpcomingSleep({Key? key, required this.sleep}) : super(key: key);

  @override
  _UpcomingSleepState createState() => _UpcomingSleepState(sleep);
}

class _UpcomingSleepState extends State<UpcomingSleep> {
   late Sleep sleep;
  _UpcomingSleepState(this.sleep);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(Icons.hotel, color: Theme.of(context).textTheme.headline4!.color,),
      Padding(
        padding: EdgeInsets.only(left: 8), 
        child: Text(sleep.startTime.toString().split(RegExp("[()]"))[1] + " Sleep")
      ),
    ]);
  }
}
