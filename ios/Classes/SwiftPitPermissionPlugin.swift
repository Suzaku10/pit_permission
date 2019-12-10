import Flutter
import UIKit
import Photos
import Contacts
import CoreLocation

public class SwiftPitPermissionPlugin: NSObject, FlutterPlugin {
    var grantedList = [Bool]()
    var permissionLength: Int?
    var isMultiplePermission: Bool?
    var permissionList: [String]?
    
    var counter: Int = 0
    
    var locationManager:CLLocationManager!
    var dispatchGroup = DispatchGroup()
    
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
            counter = 0
            isMultiplePermission = false
            let permission = call.arguments as? String
            requestSinglePermission(permission: permission ?? "Error", result: result)
        } else if (call.method.elementsEqual("requestPermissions")) {
            isMultiplePermission = true
            counter = 0
            grantedList = [Bool]()
            permissionList = [String] ()
            let permissions = call.arguments as? Dictionary<String, [String]>
            for (_, value) in permissions! {
                permissionList = value
            }
            
            permissionLength = permissionList?.count
            grantedList = [Bool](repeating: false, count: permissionLength!)
            requestPermissions(permission: permissionList!, result: result)
        } else if (call.method.elementsEqual("openAppSettings")){
            openAppSettings(result: result)
        }
    }
    
    public func openAppSettings(result: @escaping FlutterResult) -> Void{
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            result(false)
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                    result(true)
                })
            } else if #available(iOS 8.0, *) {
                UIApplication.shared.openURL(settingsUrl)
                result(true)
            } else {
                result(false)
            }
        }
    }
    
    public func requestPermissions(permission: [String],result: @escaping FlutterResult) -> Void {
        let permissionLength = permission.count
        for index in 0..<permissionLength {
            switch (permission[index]) {
            case "Contact":
                let isGranted = checkPermission(permission: permission[index])
                if isGranted {
                    self.collectPermissionResult(isGranted: true, result: result, permissionName: permission[index])
                } else{
                      contactPermission(result: result, permissionName: permission[index])
                }
                break
                
            case "Storage":
                let isGranted = checkPermission(permission: permission[index])
                if isGranted {
                    self.collectPermissionResult(isGranted: true, result: result, permissionName: permission[index])
                } else{
                   storagePermission(result: result, permissionName: permission[index])
                }
                break
                
            case "Camera":
                let isGranted = checkPermission(permission: permission[index])
                if isGranted {
                    self.collectPermissionResult(isGranted: true, result: result, permissionName: permission[index])
                } else{
                     cameraPermission(result: result, permissionName: permission[index])
                }
                break
                
            case "Microphone":
                let isGranted = checkPermission(permission: permission[index])
                if isGranted {
                    self.collectPermissionResult(isGranted: true, result: result, permissionName: permission[index])
                } else{
                  microphonePermission(result: result, permissionName: permission[index])
                }
                break
                
            case "Location":
                let isGranted = checkPermission(permission: permission[index])
                if isGranted {
                    self.collectPermissionResult(isGranted: true, result: result, permissionName: permission[index])
                } else{
                  locationPermission(result: result, permissionName: permission[index])
                }
                break
                
            case "Call Logs":
                self.collectPermissionResult(isGranted: true, result: result, permissionName: permission[index])
                break
            
            case "Sms" :
                self.collectPermissionResult(isGranted: true, result: result, permissionName: permission[index])
                break
                
            default:
                break
            }
        }
    }
    
    public func collectPermissionResult(isGranted: Bool, result: @escaping FlutterResult, permissionName: String) -> Void {
        if isMultiplePermission! {
            let permissionLength = permissionList!.count
            for index in 0..<permissionLength {
                if permissionList![index] == permissionName {
                    grantedList[index] = isGranted
                    counter += 1
                }
            }
        } else {
            result(isGranted)
        }
        
        if counter == permissionLength && isMultiplePermission! {
            if grantedList.contains(false){
                result(false)
            } else {
                result(true)
            }
        }
    }
    
    public func storagePermission(result: @escaping FlutterResult, permissionName: String) -> Void {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                self.collectPermissionResult(isGranted: true, result: result, permissionName: permissionName)
                break;
                
            case .restricted, .denied, .notDetermined:
                self.collectPermissionResult(isGranted: false, result: result, permissionName: permissionName)
                break;
                
            default:
                self.collectPermissionResult(isGranted: false, result: result, permissionName: permissionName)
                break
            }
        }
    }
    
    public func microphonePermission(result: @escaping FlutterResult, permissionName: String) -> Void {
        AVCaptureDevice.requestAccess(for: AVMediaType.audio) { granted in
            if granted {
                self.collectPermissionResult(isGranted: true, result: result, permissionName: permissionName)
            } else {
                self.collectPermissionResult(isGranted: false, result: result, permissionName: permissionName)
            }
        }
    }
    
    
    public func contactPermission(result: @escaping FlutterResult, permissionName: String) -> Void {
        if #available(iOS 9.0, *) {
            CNContactStore().requestAccess(for: .contacts, completionHandler: { granted, error in
                if (granted){
                    self.collectPermissionResult(isGranted: true, result: result, permissionName: permissionName)
                } else {
                    self.collectPermissionResult(isGranted: false, result: result, permissionName: permissionName)
                }
            })
        }
    }
    
    public func cameraPermission(result: @escaping FlutterResult, permissionName: String) -> Void {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
            if granted {
                self.collectPermissionResult(isGranted: true, result: result, permissionName: permissionName)
            } else {
                self.collectPermissionResult(isGranted: false, result: result, permissionName: permissionName)
            }
        }
    }
    
    public func locationPermission(result: @escaping FlutterResult, permissionName: String) -> Void {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        dispatchGroup.enter()
        
        locationManager.requestAlwaysAuthorization()
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            
            var permissionGranted = false
            let status = CLLocationManager.authorizationStatus()
            self.locationManager.delegate = nil
            
            switch (status) {
            case .authorizedAlways, .authorizedWhenInUse:
                permissionGranted = true
                break
            case .denied,.restricted:
                permissionGranted = false
                break
            case .notDetermined:
                permissionGranted = false
                break
            }
            self.collectPermissionResult(isGranted: permissionGranted, result: result, permissionName: permissionName)
        }
    }
    
    public func requestSinglePermission(permission: String, result: @escaping FlutterResult) -> Void {
        let isGranted = checkPermission(permission: permission)
        if !isGranted {
            if permission == "Storage" {
                storagePermission(result: result, permissionName: permission)
            } else if (permission == "Contact"){
                contactPermission(result: result, permissionName: permission)
            } else if (permission == "Camera"){
                cameraPermission(result: result, permissionName: permission)
            } else if (permission == "Microphone"){
                microphonePermission(result: result, permissionName: permission)
            } else if (permission == "Location") {
                locationPermission(result: result, permissionName: permission)
            } else if(permission == "Call Logs"){
                self.collectPermissionResult(isGranted: true, result: result, permissionName: permission)
            } else if(permission == "Sms"){
                self.collectPermissionResult(isGranted: true, result: result, permissionName: permission)
            }
        } else {
             self.collectPermissionResult(isGranted: true, result: result, permissionName: permission)
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
        } else if (permission == "Location") {
            let status = CLLocationManager.authorizationStatus()
            granted = (status == .authorizedAlways || status == .authorizedWhenInUse)
        } else if (permission == "Call Logs") {
            granted = true;
        } else if (permission == "Sms") {
            granted = true;
        }
        
        return granted ?? false
    }
    
}

extension SwiftPitPermissionPlugin: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status != .notDetermined {
            dispatchGroup.leave()
        }
        
    }
}
