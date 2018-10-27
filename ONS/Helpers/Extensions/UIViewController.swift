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
            textField.placeholder = UserDefaults.standard.value(forKey: "newssid") as? String
        })
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = UserDefaults.standard.value(forKey: "newPassword") as? String
        })
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = UserDefaults.standard.value(forKey: "ipAddress") as? String
        })
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { action in
            
            if let ipAddress = alert.textFields?.first?.text {
               
                UserDefaults.standard.set(ipAddress, forKey: "ipAddress")
               
                
            }
            if let ssid : String = alert.textFields![1].text {
                
                UserDefaults.standard.set(ssid, forKey: "newssid")
                
                if let password : String = alert.textFields![2].text {
                    
                    UserDefaults.standard.set(password, forKey: "newPassword")
                    Socket.soketmanager.send(message: "*SSID:\(String(describing: ssid.count)):\(ssid):PASSWORD:\(String(describing: password.count)):\(password)#")
                }
                
            }
            
            
            
        }))
        
        self.present(alert, animated: true)
    }
    
    
    func showFailure(){
        let alert = UIAlertController(title: "Warning", message: "Not able to make connection, please check again!!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
         self.present(alert, animated: true)
    }
}
