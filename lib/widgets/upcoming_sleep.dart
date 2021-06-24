import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sleepscheduler/data/schedule.dart';
import 'package:sleepscheduler/data/sleep.dart';
import 'package:sleepscheduler/widgets/text_dialog.dart';

import 'snackbar_handler.dart';

class UpcomingSleep extends StatefulWidget {
  final Sleep sleep;
  final Schedule schedule;

  UpcomingSleep({Key? key, required this.sleep, required this.schedule})
      : super(key: key);

  @override
  _UpcomingSleepState createState() => _UpcomingSleepState(sleep, schedule);
}

class _UpcomingSleepState extends State<UpcomingSleep> {
  late Sleep sleep;
  late Schedule schedule;
  String durationText = '';
  late FocusNode focusNode;

  _UpcomingSleepState(this.sleep, this.schedule);

  void onDelete() {
    SnackbarHandler().showSnackbar(
        context, 'Deleting ${sleep.startTime.toString()}', SnackbarType.info);
    schedule.remove(sleep);
  }

  Future<void> onEdit() async {
    String? name =
        await TextDialog.show(context, 'Enter Name'.toUpperCase(), sleep.name);
    if (name == null) return /* action canceled */;

    sleep.name = name;
    schedule.save();
  }

  @override
  void initState() {
    super.initState();

    if (sleep.duration >= 60)
      durationText = '${(sleep.duration / 60).floor()}h';
    if (sleep.duration % 60 > 0)
      durationText +=
          '${durationText.length > 0 ? ' ' : ''}${(sleep.duration % 60).ceil()}min';
    focusNode = FocusNode()
      ..addListener(() {
        print('focus');
        setState(() {}); // Rebuild.
      });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      focusNode: focusNode,
      autofocus: true,
      onTap: () => focusNode.requestFocus(),
      title: SingleChildScrollView(
        child: Text(
            '${sleep.startTime.toString().split(RegExp('[()]'))[1]} for $durationText'),
        scrollDirection: Axis.horizontal,
      ),
      subtitle: Text(sleep.name),
      leading: Icon(
        Icons.hotel,
        color: Theme.of(context).textTheme.headline4!.color,
      ),
      horizontalTitleGap: 0,
      enableFeedback: false,
      focusColor: Theme.of(context).scaffoldBackgroundColor,
      trailing: (focusNode.hasFocus)
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete),
                  splashRadius: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                IconButton(
                  onPressed: onEdit,
                  icon: Icon(Icons.edit),
                  splashRadius: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
            ),
    );
  }
}
