import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pit_permission/pit_permission.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<PermissionName, bool> grantedList;
  bool isPermissionGranted;
  bool test;

  @override
  void initState() {
    super.initState();
    permissionRequest();
  }

  Future<void> permissionRequest() async {
    List<PermissionName> permissionNameList;

    try {
      permissionNameList = [
        PermissionName.camera,
        PermissionName.microphone,
        PermissionName.location,
        PermissionName.contact,
        PermissionName.storage,
        PermissionName.phoneCall,
        PermissionName.sms
      ];

      grantedList = await PitPermission.requestPermissions(permissionNameList);
    } on PlatformException {
      print("error");
    }

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PitPermission Plugin example app'),
        ),
        body: Center(
          child: Text('result from grantedList: $grantedList\n'),
        ),
      ),
    );
  }
}
