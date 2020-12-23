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
  bool isPermissionGranted;
  bool isShowRequestPermissionRational;

  @override
  void initState() {
    super.initState();
    permissionRequest();
  }

  Future<void> permissionRequest() async {
    try {
      List<PermissionName> permissionNameList = [
        PermissionName.camera,
        PermissionName.microphone,
        PermissionName.location,
        PermissionName.contact,
        PermissionName.storage,
        PermissionName.writeStorage,
        PermissionName.phoneCall,
        PermissionName.sms
      ];

      isPermissionGranted = await PitPermission.requestPermissions(permissionNameList);
      print(isPermissionGranted.toString());

      if(!isPermissionGranted){
        isShowRequestPermissionRational = await PitPermission.shouldShowRequestPermissionRationale(permissionNameList);
        if(!isShowRequestPermissionRational) PitPermission.openAppSettings();
      }
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
      appBar: AppBar(title: const Text('PitPermission Plugin example app')),
      body: Center(child: Text("have all permission ? $isPermissionGranted")),
    ));
  }
}
