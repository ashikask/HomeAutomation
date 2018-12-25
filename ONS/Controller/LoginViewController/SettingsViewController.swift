//
//  SettingsViewController.swift
//  ONS
//
//  Created by SHIVA KUMAR on 02/10/18.
//  Copyright © 2018 ashika kalmady. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    
    @IBOutlet var timeandDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd" //Your date format
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "HH:mm:ss"
        
        self.timeandDate.text = dateFormatter.string(from: date as Date) + " " + dateFormatter2.string(from: date as Date)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func setTimeAction(_ sender: Any) {
        let stringArray = self.timeandDate.text?.split(separator: " ")
        if let string1 = stringArray?[0] , let string2 = stringArray?[1] {
        print("*RTC$$$D\(String(describing: string1)) T\(String(describing: string2))#")
            Socket.soketmanager.send(message: "*RTC$$$D\(String(describing: string1)) T\(String(describing: string2))#")
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func okAction(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
        
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
