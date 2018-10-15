//
//  SettingsViewController.swift
//  ONS
//
//  Created by SHIVA KUMAR on 02/10/18.
//  Copyright © 2018 ashika kalmady. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet var ipAddressField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var ssidField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        
        
        self.ssidField.text = sharedManager.shared.getSsid()
        self.passwordField.text = sharedManager.shared.getPassword()
        self.ipAddressField.text = sharedManager.shared.getlocalIpAddress()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func okAction(_ sender: UIButton) {
        
        
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
