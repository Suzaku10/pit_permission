# PIT Permission

This is Permission Plugin, that can use for requesting permission in IOS or Android

*Note*: This plugin is still under development, and some Components might not be available yet or still has so many bugs.

## Installation

First, add `pit_permission` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

```
pit_permission: ^0.0.1
```

## Important

You must add this permission in AndroidManifest.xml for Android

```
for using Camera = <uses-permission android:name="android.permission.CAMERA"/>
for using Microphone = <uses-permission android:name="android.permission.RECORD_AUDIO"/>
for read Storage = <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
for read Contact = <uses-permission android:name="android.permission.READ_CONTACTS"/>
```

And you must add this on info.plist for IOS

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

## Example for Check Permission
```
bool isPermissionGranted = await PitPermission.checkPermission(PermissionName.Microphone);
```

## Example for Request Single Permission
```
bool cameraGranted = await PitPermission.requestSinglePermission(PermissionName.Camera);
```

## Example for Request Permissions
```
 List<PermissionName> permissionNameList = [
        PermissionName.Camera,
        PermissionName.Microphone,
        PermissionName.Contact,
        PermissionName.Storage,
      ];

 Map<PermissionName, bool> grantedList; = await PitPermission.requestPermissions(permissionNameList);
```