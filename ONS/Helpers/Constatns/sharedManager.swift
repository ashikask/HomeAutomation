//
//  sharedManager.swift
//  ONS
//
//  Created by ashika on 06/07/18.
//  Copyright © 2018 ashika kalmady. All rights reserved.
//

import Foundation
class sharedManager {
    
    // MARK: - Properties
    
    static let shared = sharedManager()
    var previousMood : Mood?
    var localipAddess : String = "192.168.4.1"
    var ipAddess : String = "122.166.170.62"
    var ssid : String = ""
    var password : String = ""
    // Initialization
    
    func setIpAddress(newIp : String){
        self.ipAddess = newIp
    }
    
    func getIpAddress() -> String
    {
        return self.ipAddess
    }
    
    func setlocalIpAddress(newIp : String){
        self.localipAddess = newIp
    }
    
    func getlocalIpAddress() -> String
    {
        return self.localipAddess
    }
    
    func setSsid(newSSID : String){
        self.ssid = newSSID
    }
    
    func getSsid() -> String
    {
        return self.ssid
    }
    func setPassword(newPassword : String){
        self.password = newPassword
    }
    
    func getPassword() -> String
    {
        return self.password
    }
    
    private init() {
       
    }
    
}
