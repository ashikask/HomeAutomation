//
//  UIViewController.swift
//  ONS
//
//  Created by SHIVA KUMAR on 11/10/18.
//  Copyright © 2018 ashika kalmady. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func showSettings(){
        let alert = UIAlertController(title: "Settings", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = sharedManager.shared.getSsid()
        })
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = sharedManager.shared.getPassword()
        })
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = sharedManager.shared.getIpAddress()
        })
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { action in
            
            if let ipAddress = alert.textFields?.first?.text {
                sharedManager.shared.setIpAddress(newIp: ipAddress)
                
                
            }
            if let ssid : String = alert.textFields![1].text {
                sharedManager.shared.setSsid(newSSID: ssid)
                if let password : String = alert.textFields![2].text {
                    sharedManager.shared.setPassword(newPassword: password)
                    
                    Socket.soketmanager.send(message: "*SSID:\(String(describing: ssid.count)):\(ssid):PASSWORD:\(String(describing: password.count)):\(password)#")
                }
                
            }
            
            
            
        }))
        
        self.present(alert, animated: true)
    }
}
