import 'package:flutter/material.dart';
import 'package:sleepscheduler/data/sleep.dart';
import 'package:sleepscheduler/widgets/text_dialog.dart';

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
  late Function onDelete, onEdit;
  String durationText = '';

  _UpcomingSleepState(this.sleep, this.onDelete, this.onEdit);

  void onDeletePressed() {
    onDelete(sleep);
  }

  Future<void> onEditPressed() async {
    String? name = await TextDialog.show(context, 'Enter Name'.toUpperCase(), sleep.name);
    if (name == null) return /* action canceled */;
    
    sleep.name = name;
    onEdit(sleep);
  }

  @override
  void initState() {
    super.initState();

    if (sleep.duration > 60) durationText = '${(sleep.duration / 60).floor()}h';
    if (sleep.duration % 60 > 0) durationText += '${durationText.length > 0 ? ' ' : ''}${sleep.duration % 60}min';
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        Icon(
          Icons.hotel,
          color: Theme.of(context).textTheme.headline4!.color,
        ),
        Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text(
                '${sleep.startTime.toString().split(RegExp('[()]'))[1]} ${sleep.name} for $durationText')
        ),
      ]),
      Row(children: [
        IconButton(
          onPressed: onDeletePressed,
          icon: Icon(Icons.delete),
          splashRadius: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        IconButton(
          onPressed: onEditPressed,
          icon: Icon(Icons.edit),
          splashRadius: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
      ]),
    ]);
  }
}
