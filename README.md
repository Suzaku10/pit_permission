# PIT Permission

This is Permission Plugin, that can use for requesting permission in IOS or Android

*Note*: This plugin is still under development, and some Components might not be available yet or still has so many bugs.

## Installation

First, add `pit_permission` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

```
pit_permission: ^0.1.1
```

## Important

You must add this permission in AndroidManifest.xml for Android

```
for using Camera = <uses-permission android:name="android.permission.CAMERA"/>
for using Microphone = <uses-permission android:name="android.permission.RECORD_AUDIO"/>
for read Storage = <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
for read Contact = <uses-permission android:name="android.permission.READ_CONTACTS"/>
for using Location = <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
for read SMS = <uses-permission android:name="android.permission.READ_SMS"/>
for read Call Logs = <uses-permission android:name="android.permission.READ_CALL_LOG"/>
```

And you must add this on info.plist for IOS

*Note*: reqeust SMS and Call Logs in IOS always return true, but it doesn't functionally

### For using camera
```
 <key>NSCameraUsageDescription</key>
 <string>${PRODUCT_NAME} Need To Access Your Camera</string>
```

### For using microphone
```
 <key>NSMicrophoneUsageDescription</key>
 <string>${PRODUCT_NAME} Need To Access Your Microphone</string>
```

### For read storage
```
 <key>NSPhotoLibraryUsageDescription</key>
 <string>${PRODUCT_NAME} Need To Access Your Photo</string>
```

### For read contact
```
 <key>NSContactsUsageDescription</key>
 <string>${PRODUCT_NAME} Need To Access Your Contact</string>
```

### For using location
```
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>${PRODUCT_NAME} Need To Access Your Location</string>
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>${PRODUCT_NAME} Need To Access Your Location</string>
```

## Example for Check Permission
```
bool isPermissionGranted = await PitPermission.checkPermission(PermissionName.microphone);
```

## Example for Request Single Permission
```
bool cameraGranted = await PitPermission.requestSinglePermission(PermissionName.camera);
```

## Example for Request Permissions working on <= 0.1.0

```
 List<PermissionName> permissionNameList = [
        PermissionName.camera,
        PermissionName.microphone,
        PermissionName.contact,
        PermissionName.storage,
        PermissionName.phoneCall,
        PermissionName.sms,
      ];

 Map<PermissionName, bool> grantedList; = await PitPermission.requestPermissions(permissionNameList);
```

## Example for Request Permissions working on  0.1.1
```
 List<PermissionName> permissionNameList = [
        PermissionName.camera,
        PermissionName.microphone,
        PermissionName.contact,
        PermissionName.storage,
        PermissionName.phoneCall,
        PermissionName.sms,
      ];

 Map<PermissionName, bool> grantedList; = await PitPermission.requestPermissions(permissionNameList);
```