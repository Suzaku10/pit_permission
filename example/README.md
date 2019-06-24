# example/README.md
```
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

  @override
  void initState() {
    super.initState();
    permissionRequest();
  }

  Future<void> permissionRequest() async {
    List<PermissionName> permissionNameList;

    try {
      permissionNameList = [
        PermissionName.Camera,
        PermissionName.Microphone,
        PermissionName.Contact,
        PermissionName.Storage,
      ];
      isPermissionGranted = await PitPermission.checkPermission(PermissionName.Microphone);
      print("is Microphone Permission Granted ? ${isPermissionGranted}");

      isPermissionGranted = await PitPermission.checkPermission(PermissionName.Camera);
      print("is Camera Permission Granted ? ${isPermissionGranted}");

      isPermissionGranted = await PitPermission.checkPermission(PermissionName.Contact);
      print("is Contact Permission Granted ? ${isPermissionGranted}");

      isPermissionGranted = await PitPermission.checkPermission(PermissionName.Storage);
      print("is Storage Permission Granted ? ${isPermissionGranted}");

      grantedList = await PitPermission.requestPermissions(permissionNameList);

      isPermissionGranted = await PitPermission.checkPermission(PermissionName.Microphone);
      print("is Microphone Permission Granted ? ${isPermissionGranted}");

      isPermissionGranted = await PitPermission.checkPermission(PermissionName.Camera);
      print("is Camera Permission Granted ? ${isPermissionGranted}");

      isPermissionGranted = await PitPermission.checkPermission(PermissionName.Contact);
      print("is Contact Permission Granted ? ${isPermissionGranted}");

      isPermissionGranted = await PitPermission.checkPermission(PermissionName.Storage);
      print("is Storage Permission Granted ? ${isPermissionGranted}");
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
```

