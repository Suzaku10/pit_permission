package com.padimas.pitpermission;

import android.Manifest;
import android.content.pm.PackageManager;
import android.util.Log;

import androidx.core.app.ActivityCompat;

import java.util.ArrayList;
import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * PitPermissionPlugin
 */
public class PitPermissionPlugin implements MethodCallHandler, PluginRegistry.RequestPermissionsResultListener {
    public PitPermissionPlugin(Registrar registrar) {
        this.registrar = registrar;
    }

    Registrar registrar;
    Result result;

    int REQUEST_CODE_SINGLE_PERMISSION = 0;
    int REQUEST_CODE_MULTIPLE_PERMISSION = 19;

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "pit_permission");
        PitPermissionPlugin pitPermission = new PitPermissionPlugin(registrar);
        channel.setMethodCallHandler(pitPermission);
        registrar.addRequestPermissionsResultListener(pitPermission);
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        boolean permissionGranted;
        String permission;

        switch (call.method) {
            case "checkPermission":
                permission = call.arguments.toString();
                permissionGranted = checkPermission(permission);
                result.success(permissionGranted);
                break;

            case "requestSinglePermission":
                this.result = result;
                permission = call.arguments.toString();
                requestSinglePermission(permission);
                break;

            case "requestPermissions":
                List<String> permissions = call.argument("permissions");
                this.result = result;
                requestPermissions(permissions);
                break;

            default:
                result.notImplemented();
                break;
        }
    }


    public boolean checkPermission(String permission) {
        int result = ActivityCompat.checkSelfPermission(registrar.context(), getPermissionString(permission));
        return result == PackageManager.PERMISSION_GRANTED;
    }

    public void requestSinglePermission(String permission) {
        String[] permissions = {getPermissionString(permission)};
        Boolean checkPermission = checkPermission(permission);
        if (checkPermission) {
            result.success(checkPermission);
            return;
        }
        ActivityCompat.requestPermissions(registrar.activity(), permissions, REQUEST_CODE_SINGLE_PERMISSION);
    }

    public void requestPermissions(List<String> permissions) {
        List<String> permissionList = new ArrayList<>();
        for (int i = 0; i < permissions.size(); i++) {
            boolean checkPermission = checkPermission(permissions.get(i));
            if (!checkPermission) {
                permissionList.add(getPermissionString(permissions.get(i)));
            }
        }
        String[] permissionArray = permissionList.toArray(new String[0]);
        if (permissionArray.length == 0) {
            result.success(true);
            return;
        }
        ActivityCompat.requestPermissions(registrar.activity(), permissionArray, REQUEST_CODE_MULTIPLE_PERMISSION);
    }

    @Override
    public boolean onRequestPermissionsResult(int requestCode, String[] strings, int[] ints) {
        if (requestCode == REQUEST_CODE_SINGLE_PERMISSION) {
            if (ints[0] == PackageManager.PERMISSION_GRANTED) {
                result.success(true);
            } else {
                result.success(false);
            }
        } else if (requestCode == REQUEST_CODE_MULTIPLE_PERMISSION && ints.length > 0) {
            List<Boolean> grantedList = new ArrayList<>();
            for (int i = 0; i < ints.length; i++) {
                if (ints[i] == PackageManager.PERMISSION_GRANTED) {
                    grantedList.add(true);
                } else {
                    grantedList.add(false);
                }
            }
            if (grantedList.contains(false)) {
                result.success(false);
            } else {
                result.success(true);
            }
        }
        return false;
    }

    private String getPermissionString(String permissionName) {
        String permission = "";

        switch (permissionName) {
            case "Contact":
                permission = Manifest.permission.READ_CONTACTS;
                break;

            case "Storage":
                permission = Manifest.permission.READ_EXTERNAL_STORAGE;
                break;

            case "Camera":
                permission = Manifest.permission.CAMERA;
                break;

            case "Microphone":
                permission = Manifest.permission.RECORD_AUDIO;
                break;

            case "Location":
                permission = Manifest.permission.ACCESS_FINE_LOCATION;
                break;

            case "PhoneCall":
                permission = Manifest.permission.READ_CALL_LOG;
                break;

            case "Sms":
                permission = Manifest.permission.READ_SMS;
                break;
        }
        return permission;
    }
}
