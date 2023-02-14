import 'package:flutter/material.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static showErrorSnackBar(String? text, BuildContext context) {
    if (text == null) return;
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: Theme.of(context).colorScheme.error,
    );
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static showSnackBar(String? text, BuildContext context) {
    if (text == null) return;
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
