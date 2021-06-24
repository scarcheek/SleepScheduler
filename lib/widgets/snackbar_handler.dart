import 'package:flutter/material.dart';

enum SnackbarType { error, success, info, warning }

class SnackbarHandler {
  void showSnackbar(BuildContext context, String message, SnackbarType type) {
    Duration duration;

    switch (type) {
      case SnackbarType.error:
        duration = Duration(seconds: 5);
        break;
      case SnackbarType.warning:
        duration = Duration(seconds: 5);
        break;
      default:
        duration = Duration(seconds: 1);
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
      duration: duration,
      width: 280.0, // Width of the SnackBar.
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0, // Inner padding for SnackBar content.
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
    ));
  }
}
