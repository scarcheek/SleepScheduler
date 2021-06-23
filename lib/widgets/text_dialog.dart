import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextDialog {

  static Future<String?> show(BuildContext context, String title, String initialValue) {
    return showDialog(context: context, builder: (context) => TextDialogWidget(initialValue: initialValue));
  }

}

class TextDialogWidget extends StatefulWidget {
  final String initialValue;
  TextDialogWidget({Key? key, required this.initialValue}) : super(key: key);

  @override
  _TextDialogWidgetState createState() => _TextDialogWidgetState(initialValue);
}

class _TextDialogWidgetState extends State<TextDialogWidget> {
  late String value;
  _TextDialogWidgetState(this.value);

  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode()..addListener(() {
      setState(() { }); // Rebuild.
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter name'.toUpperCase(), style: TextStyle(
          color: TimePickerTheme.of(context).helpTextStyle!.color,
          fontSize: 15,
      )),
      content: TextFormField(
        initialValue: value,
        onChanged: (val) => value = val,
        onEditingComplete: () => Navigator.pop(context, value),
        textAlign: TextAlign.center,
        focusNode: focusNode,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          filled: true,
          fillColor: focusNode.hasFocus ? Colors.transparent : Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 2.0),
          ),
          // TODO(rami-a): Remove this logic once https://github.com/flutter/flutter/issues/54104 is fixed.
          errorStyle: const TextStyle(fontSize: 0.0, height: 0.0), // Prevent the error text from appearing.
        ),
      ),
      actions: <Widget>[
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel'.toUpperCase())),
        TextButton(onPressed: () => Navigator.pop(context, value), child: Text('Ok'.toUpperCase())),
      ],
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}
