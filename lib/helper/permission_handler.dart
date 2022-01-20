import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

//only ask for microphone permissions once
class PermissionHandler {
  static final PermissionHandler _instance = PermissionHandler();
  bool _requesting = false;

  static Future<bool> request(BuildContext context) async {
    if(!_instance._requesting) {
      _instance._requesting = true;
      await Permission.microphone.request();
      _instance._requesting = false;
    }
    bool granted = await Permission.microphone.isGranted;
    if(!granted) showDialog(context: context, builder: (context) => AlertDialog(title: Text('please allow permissions!')));
    return granted;
  }
}