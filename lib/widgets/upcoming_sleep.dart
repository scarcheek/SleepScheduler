import 'package:flutter/material.dart';
import 'package:sleepscheduler/data/sharedpref.dart';
import 'package:sleepscheduler/data/sleep.dart';

class UpcomingSleep extends StatefulWidget {
  final Sleep sleep;
  final Function onDelete;
  final Function onEdit;

  UpcomingSleep(
      {Key? key,
      required this.sleep,
      required this.onDelete,
      required this.onEdit})
      : super(key: key);

  @override
  _UpcomingSleepState createState() =>
      _UpcomingSleepState(sleep, onDelete, onEdit);
}

class _UpcomingSleepState extends State<UpcomingSleep> {
  late Sleep sleep;
  late Function callBack, onEdit;
  _UpcomingSleepState(this.sleep, this.callBack, this.onEdit);

  void onDeletePressed() {
    callBack(sleep);
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      IconButton(
        onPressed: onDeletePressed,
        icon: Icon(Icons.delete),
        splashRadius: 20,
        color: Theme.of(context).colorScheme.primary,
      ),
      Icon(
        Icons.hotel,
        color: Theme.of(context).textTheme.headline4!.color,
      ),
      Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
              sleep.startTime.toString().split(RegExp("[()]"))[1] + " Sleep")),
    ]);
  }
}
