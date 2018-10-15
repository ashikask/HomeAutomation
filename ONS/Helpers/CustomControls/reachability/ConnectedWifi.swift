//
//  ConnectedWifi.swift
//  ONS
//
//  Created by SHIVA KUMAR on 01/09/18.
//  Copyright © 2018 ashika kalmady. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork

class ConnectedWifi{
    
    func getWiFiSsid() -> String? {
//        var ssid: String?
//        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
//            for interface in interfaces {
//                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
//                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
//                    break
//                }
//            }
//        }
//        return ssid
        
        var currentSSID = ""
        if let interfaces:CFArray = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interfaces){
                let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                if unsafeInterfaceData != nil {
                    
                    let interfaceData = unsafeInterfaceData! as Dictionary!
                    currentSSID = ((interfaceData as? [String : AnyObject])?["SSID"])! as! String
                    
                }
            }
        }
        return currentSSID
    }
    
    
    func fetchSSIDInfo() -> [String: Any] {
        var interface = [String: Any]()
        if let interfaces = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interfaces){
                let interfaceName = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
               
                guard let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString) else {
                    return interface
                }
                guard let interfaceData = unsafeInterfaceData as? [String: Any] else {
                    return interface
                }
                interface = interfaceData
            }
        }
        return interface
    }

}
