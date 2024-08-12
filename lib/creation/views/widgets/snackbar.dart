
import 'package:flutter/material.dart';

void displaySnackbar(BuildContext context,
    {String msg = "Feature is under development", GlobalKey<ScaffoldMessengerState>? key}) {
  final snackBar = SnackBar(
    content: Text(msg),
    duration: const Duration(seconds: 3),
  );
  if (key != null && key.currentState != null) {
    key.currentState!.hideCurrentSnackBar();
    key.currentState!.showSnackBar(snackBar);
  } else {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}