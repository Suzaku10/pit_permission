import Flutter
import UIKit
import Photos
import Contacts
import CoreLocation

public class SwiftPitPermissionPlugin: NSObject, FlutterPlugin {
    var grantedList = [Bool]()
    var permissionLength: Int?
    var isMultiplePermission: Bool?
    
    var locationManager:CLLocationManager!
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "pit_permission", binaryMessenger: registrar.messenger())
        let instance = SwiftPitPermissionPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method.elementsEqual("checkPermission"){
            let permission = call.arguments as? String
            let granted = checkPermission(permission: permission ?? "Error")
            result(granted)
        } else if (call.method.elementsEqual("requestSinglePermission")){
            permissionLength = 0
            isMultiplePermission = false
            let permission = call.arguments as? String
            requestSinglePermission(permission: permission ?? "Error", result: result)
        } else if (call.method.elementsEqual("requestPermissions")) {
            isMultiplePermission = true
            grantedList = [Bool]()
            let permissions = call.arguments as? Dictionary<String, [String]>
            var permissionList: [String]?
            for (_, value) in permissions! {
                permissionList = value
            }
            
            permissionLength = permissionList?.count
            requestPermissions(permission: permissionList!, result: result)
        }
    }
    
    public func requestPermissions(permission: [String],result: @escaping FlutterResult) -> Void {
        let permissionLength = permission.count
        for index in 0..<permissionLength {
            print(permission[index])
            switch (permission[index]) {
            case "Contact":
                contactPermission(result: result)
                break
                
            case "Storage":
                storagePermission(result: result)
                break
                
            case "Camera":
                cameraPermission(result: result)
                break
                
            case "Microphone":
                microphonePermission(result: result)
                break
                
            default:
                break
            }
        }
    }
    
    public func collectPermissionResult(isGranted: Bool, result: @escaping FlutterResult) -> Void {
        if isMultiplePermission! {
            grantedList.append(isGranted)
        } else {
            result(isGranted)
        }
        
        if grantedList.count == permissionLength && isMultiplePermission! {
            result(grantedList)
        }
    }
    
    public func storagePermission(result: @escaping FlutterResult) -> Void {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                self.collectPermissionResult(isGranted: true, result: result)
                break;
                
            case .restricted, .denied, .notDetermined:
                self.collectPermissionResult(isGranted: false, result: result)
                break;
                
            default:
                self.collectPermissionResult(isGranted: false, result: result)
                break
            }
        }
    }
    
    public func microphonePermission(result: @escaping FlutterResult) -> Void {
        AVCaptureDevice.requestAccess(for: AVMediaType.audio) { granted in
            if granted {
                self.collectPermissionResult(isGranted: true, result: result)
            } else {
                self.collectPermissionResult(isGranted: false, result: result)
            }
        }
    }
    
    
    public func contactPermission(result: @escaping FlutterResult) -> Void {
        if #available(iOS 9.0, *) {
            CNContactStore().requestAccess(for: .contacts, completionHandler: { granted, error in
                if (granted){
                    self.collectPermissionResult(isGranted: true, result: result)
                } else {
                    self.collectPermissionResult(isGranted: false, result: result)
                }
            })
        }
    }
    
    public func cameraPermission(result: @escaping FlutterResult) -> Void {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
            if granted {
                self.collectPermissionResult(isGranted: true, result: result)
            } else {
                self.collectPermissionResult(isGranted: false, result: result)
            }
        }
    }
    
    public func requestSinglePermission(permission: String, result: @escaping FlutterResult) -> Void {
        if permission == "Storage" {
            storagePermission(result: result)
        } else if (permission == "Contact"){
            contactPermission(result: result)
        } else if (permission == "Camera"){
            cameraPermission(result: result)
        } else if (permission == "Microphone"){
            microphonePermission(result: result)
        }
    }
    
    public func checkPermission(permission: String) -> Bool {
        var granted: Bool?
        if permission == "Storage" {
            let status = PHPhotoLibrary.authorizationStatus()
            granted = status == PHAuthorizationStatus.authorized
        } else if (permission == "Contact") {
            if #available(iOS 9.0, *) {
                let status = CNContactStore.authorizationStatus(for: .contacts)
                granted = status == CNAuthorizationStatus.authorized
            }
        } else if (permission == "Camera") {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            granted = status == AVAuthorizationStatus.authorized
        } else if (permission == "Microphone") {
            let status = AVCaptureDevice.authorizationStatus(for: .audio)
            granted = status == AVAuthorizationStatus.authorized
        } 
        return granted ?? false
    }
}