import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class PitPermission {
  static const MethodChannel _channel = const MethodChannel('pit_permission');

  static Future<bool> checkPermission(PermissionName permissionName) async {
    String permission = getPermissionString(permissionName);
    final bool granted = await _channel.invokeMethod("checkPermission", permission);
    return granted;
  }

  static Future<bool> requestSinglePermission(PermissionName permissionName) async {
    String permission = getPermissionString(permissionName);
    final bool granted = await _channel.invokeMethod("requestSinglePermission", permission);
    return granted;
  }

  static Future<bool> requestPermissions(List<PermissionName> permissionNameList) async {
    List<String> list = [];
    permissionNameList.forEach((p) {
      list.add(getPermissionString(p));
    });

    bool finalResult = await _channel.invokeMethod("requestPermissions", {"permissions": list});
    return finalResult;
  }

  static Future<bool> openAppSettings() async {
    final bool hasOpened = await _channel.invokeMethod('openAppSettings');

    return hasOpened;
  }

  static Future<bool> shouldShowRequestPermissionRationale(
      List<PermissionName> permissionNameList) async {
    if (!Platform.isAndroid) {
      return false;
    }

    List<String> list = [];
    permissionNameList.forEach((p) {
      list.add(getPermissionString(p));
    });

    final bool shouldShowRationale = await _channel.invokeMethod(
        'shouldShowRequestPermissionRationale', {"permissions": list});
    return shouldShowRationale;
  }

  static Future<List<String>> getdisablePermission(List<PermissionName> permissionNameList) async {
    List<String> list = [];

    await Future.forEach(permissionNameList,(p) async  {
      bool permission = await checkPermission(p);
      if(!permission)
        list.add(getPermissionString(p));
    });

    return list;
  }
}

enum PermissionName { contact, storage, camera, microphone, location, phoneCall, sms }



String getPermissionString(PermissionName permissions) {
  String permissionString;
  switch (permissions) {
    case PermissionName.storage:
      permissionString = "Storage";
      break;

    case PermissionName.contact:
      permissionString = "Contact";
      break;

    case PermissionName.camera:
      permissionString = "Camera";
      break;

    case PermissionName.microphone:
      permissionString = "Microphone";
      break;

    case PermissionName.location:
      permissionString = "Location";
      break;

    case PermissionName.phoneCall:
      permissionString = "Call Logs";
      break;

    case PermissionName.sms:
      permissionString = "Sms";
      break;
  }
  return permissionString;
}
