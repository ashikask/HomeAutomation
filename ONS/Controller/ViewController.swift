//
//  ViewController.swift
//  ONS
//
//  Created by ashika kalmady on 02/05/18.
//  Copyright © 2018 ashika kalmady. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changeIp(_ sender: UIButton) {
        self.showIPSettings {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func changeNetwork(_ sender: UIButton) {
        
        
        guard let status = Network.reachability?.status else { return }
        let wifissid = ConnectedWifi().getWiFiSsid()
        switch(status){
        case .wifi:
            
                if wifissid == "qiming_wifi"{
                    self.showSettings {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                else{
                                        let alert = UIAlertController(title: "Information", message: "Connect to local router", preferredStyle: .alert)
                                        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                        alert.addAction(cancel)
                                        self.present(alert, animated: true, completion: nil)
                    
                    
                    
                }
                
            
            
            break
        case .wwan:
        let alert = UIAlertController(title: "Information", message: "Connect to local router", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
            break
        case .unreachable:
        let alert = UIAlertController(title: "Information", message: "Connect to local router", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
            break
        }
    
    }
    
}

