//
//  LoginViewController.swift
//  ONS
//
//  Created by ashika kalmady on 02/05/18.
//  Copyright © 2018 ashika kalmady. All rights reserved.
//

import UIKit
import CoreData
import SystemConfiguration.CaptiveNetwork

class LoginViewController: UIViewController , SocketStreamDelegate{
    func socketDidConnect(stream: Stream) {
        
    }
    
    func socketDidReceivePopMessage(stream: Stream, message: String) {
                                        let alert = UIAlertController(title: "Warning", message: "Not able to make connection, please check again!!", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
                                        // show alert
                                        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                                        alertWindow.rootViewController = UIViewController()
                                        alertWindow.windowLevel = UIWindowLevelAlert + 1;
                                        alertWindow.makeKeyAndVisible()
                                        alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
    }
    @IBOutlet var wifiView: UIView!
    let coredataUtility : CoreDataUtility = CoreDataUtility.init()
    @IBOutlet var txt_user: LeftImageTextField!
    @IBOutlet var txt_pwd: LeftImageTextField!
   
    @IBOutlet var settingsView: UIView!
    @IBOutlet var ipAddressField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var ssidField: UITextField!
    var wifissid : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wifiView.isHidden = true
        Socket.soketmanager.delegate = self
        // Do any additional setup after loading the view.
        
  
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.wifissid = ConnectedWifi().getWiFiSsid()
        
       wifiView.isHidden = true
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
       
        
        guard let status = Network.reachability?.status else { return }
        
        switch(status){
        case .wifi:
            
            if launchedBefore  {
                if wifissid == "qiming_wifi"{
                    sharedManager.shared.setlocalIpAddress(newIp: HomeAppliancesConstant.localipAddress)
                    Socket.soketmanager.open(host: sharedManager.shared.getlocalIpAddress(), port: 1336)
                }
                else{
                    Socket.soketmanager.open(host: UserDefaults.standard.value(forKey: "ipAddress") as? String, port: 1336)
                }
                Socket.soketmanager.send(message: "@")
                Socket.soketmanager.send(message: "@")
                let modalViewController : AppliancesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppliancesViewController") as! AppliancesViewController
                let navController = UINavigationController(rootViewController: modalViewController) // Creating a navigation controller with VC1 at the root of the navigation stack.
                self.present(navController, animated:true, completion: nil)
                
            }
            else {
                if wifissid == "qiming_wifi"{
//                    sharedManager.shared.setlocalIpAddress(newIp: HomeAppliancesConstant.localipAddress)
//                    Socket.soketmanager.open(host: sharedManager.shared.getlocalIpAddress(), port: 1336)
                //    UserDefaults.standard.set(true, forKey: "launchedBefore")
                }
                else{
//                    let alert = UIAlertController(title: "Information", message: "Connect to local router", preferredStyle: .alert)
//                    let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                    alert.addAction(cancel)
//                    self.present(alert, animated: true, completion: nil)
//                    wifiView.isHidden = false
                    
                   
                }
                
            }
            
            break
        case .wwan:
            if launchedBefore  {
                Socket.soketmanager.open(host: UserDefaults.standard.value(forKey: "ipAddress") as? String, port: 1336)
            }
            else{
                let alert = UIAlertController(title: "Information", message: "Connect to local router", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
                wifiView.isHidden = false
            }
            break
        case .unreachable:
            wifiView.isHidden = false
            break
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func skipAction(_ sender: UIButton) {
        
        guard let status = Network.reachability?.status else { return }
        let wifissidString = ConnectedWifi().getWiFiSsid()
        switch(status){
        case .wifi:
            
            if wifissidString == "qiming_wifi"{
                 wifiView.isHidden = true
                //*SSID:5:Sarga:PASSWORD:5:S@6g@#
               // UserDefaults.standard.set(ipAddressField.text!, forKey: "ipAddress")
                //  UserDefaults.standard.set(ssidField.text!, forKey: "newssid")
                //  UserDefaults.standard.set(passwordField.text!, forKey: "newPassword")
                
                //    Socket.soketmanager.send(message: "*SSID:\(String(describing: ssidField.text!.count)):\(ssidField.text!):PASSWORD:\(String(describing: passwordField.text!.count)):\(passwordField.text!)#")
                
                sharedManager.shared.setlocalIpAddress(newIp: HomeAppliancesConstant.localipAddress)
                Socket.soketmanager.open(host: sharedManager.shared.getlocalIpAddress(), port: 1336)
                Socket.soketmanager.send(message: "@")
                Socket.soketmanager.send(message: "@")
                let modalViewController : AppliancesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppliancesViewController") as! AppliancesViewController
                let navController = UINavigationController(rootViewController: modalViewController) // Creating a navigation controller with VC1 at the root of the navigation stack.
                self.present(navController, animated:true, completion: nil)
                
            }
            else{
                 wifiView.isHidden = false
            }
            break
        case .wwan:
            break
        case .unreachable:
            break
        }
        
    }
    
    @IBAction func settingsOkAction(_ sender: Any) {
        
        if  ipAddressField.text == ""
        {
            let alert = UIAlertController(title: "Information", message: "Please enter the data", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
       else{
             guard let status = Network.reachability?.status else { return }
           let wifissidString = ConnectedWifi().getWiFiSsid()
            switch(status){
            case .wifi:
                
                if wifissidString == "qiming_wifi"{
                   
                    //*SSID:5:Sarga:PASSWORD:5:S@6g@#
                    UserDefaults.standard.set(ipAddressField.text!, forKey: "ipAddress")
                  //  UserDefaults.standard.set(ssidField.text!, forKey: "newssid")
                  //  UserDefaults.standard.set(passwordField.text!, forKey: "newPassword")
                    
                //    Socket.soketmanager.send(message: "*SSID:\(String(describing: ssidField.text!.count)):\(ssidField.text!):PASSWORD:\(String(describing: passwordField.text!.count)):\(passwordField.text!)#")
                     Socket.soketmanager.open(host: sharedManager.shared.getlocalIpAddress(), port: 1336)
                    Socket.soketmanager.send(message: "@")
                    Socket.soketmanager.send(message: "@")
                    let modalViewController : AppliancesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppliancesViewController") as! AppliancesViewController
                    let navController = UINavigationController(rootViewController: modalViewController) // Creating a navigation controller with VC1 at the root of the navigation stack.
                    self.present(navController, animated:true, completion: nil)
                    UserDefaults.standard.set(true, forKey: "launchedBefore")
                }
                else{
                     UserDefaults.standard.set(ipAddressField.text!, forKey: "ipAddress")
                   Socket.soketmanager.open(host: UserDefaults.standard.value(forKey: "ipAddress") as? String, port: 1336)
                    Socket.soketmanager.send(message: "@")
                    Socket.soketmanager.send(message: "@")
                    let modalViewController : AppliancesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppliancesViewController") as! AppliancesViewController
                    let navController = UINavigationController(rootViewController: modalViewController) // Creating a navigation controller with VC1 at the root of the navigation stack.
                    self.present(navController, animated:true, completion: nil)
                    UserDefaults.standard.set(true, forKey: "launchedBefore")
                }
                break
            case .wwan:
                break
            case .unreachable:
                break
            }
        }
        
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        if txt_user.text == "" || txt_pwd.text == ""
        {
            let alert = UIAlertController(title: "Information", message: "Its Mandatory to enter all the fields", preferredStyle: .alert)
            
            
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
            
        }
            
        else
        {
            let predicate = NSPredicate(format: "userName = %@ AND loginpassword = %@", txt_user.text!,txt_pwd.text!)
            
            if  let userList  =  coredataUtility.arrayOf(User.self, predicate: predicate, sortDescriptor: nil) {
                
                
                guard let status = Network.reachability?.status else { return }
               
                print("Reachability Summary")
                print("Status:", status)
                print("HostName:", Network.reachability?.hostname ?? "nil")
                print("Reachable:", Network.reachability?.isReachable ?? "nil")
                print("Wifi:", Network.reachability?.isReachableViaWiFi ?? "nil")
                
                
                //  print(roomLists ?? 0)
                let userLists : [User] = userList as! [User]
                if userLists.count > 0 {
                    let alert = UIAlertController(title: "Information", message: "Do you want to connect locally or remotely", preferredStyle: .alert)
                    
                    
                    let local = UIAlertAction(title: "Local", style: .default) { (alert) in
                        sharedManager.shared.setIpAddress(newIp: HomeAppliancesConstant.localipAddress)
                         Socket.soketmanager.open(host: sharedManager.shared.getIpAddress(), port: 1336)
                        let modalViewController : AppliancesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppliancesViewController") as! AppliancesViewController
                        let navController = UINavigationController(rootViewController: modalViewController) // Creating a navigation controller with VC1 at the root of the navigation stack.
                        self.present(navController, animated:true, completion: nil)
                    }
                    
                    let remote = UIAlertAction(title: "Remote", style: .default) { (alert) in
                        let alert = UIAlertController(title: "Enter the IP", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        
                        alert.addTextField(configurationHandler: { textField in
                            textField.placeholder = "Input IP here..."
                        })
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            
                            if let ipAddress = alert.textFields?.first?.text {
                                sharedManager.shared.setIpAddress(newIp: ipAddress)
                                 Socket.soketmanager.open(host: sharedManager.shared.getIpAddress(), port: 1336)
                                let modalViewController : AppliancesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppliancesViewController") as! AppliancesViewController
                                let navController = UINavigationController(rootViewController: modalViewController) // Creating a navigation controller with VC1 at the root of the navigation stack.
                                self.present(navController, animated:true, completion: nil)
                            }
                        }))
                        
                        self.present(alert, animated: true)
                    }
                    
                    alert.addAction(local)
                    alert.addAction(remote)
                    
                    self.present(alert, animated: true, completion: nil)
                   
                    
                    
                }
            }
                else{
                    let alert = UIAlertController(title: "Warning", message: "User is not register please register", preferredStyle: .alert)
                    
                    let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alert.addAction(cancel)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            
            
        }
        
        
    }
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        if txt_user.text == "" || txt_pwd.text == ""
        {
            let alert = UIAlertController(title: "Information", message: "Its Mandatort to enter all the fields", preferredStyle: .alert)
            
          
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
           
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
            
        }
          
        else
        {
            let predicate = NSPredicate(format: "userName = %@ AND loginpassword = %@", txt_user.text!,txt_pwd.text!)
        
            if  let _  =  coredataUtility.arrayOf(User.self, predicate: predicate, sortDescriptor: nil) {
                //  print(roomLists ?? 0)
                let alert = UIAlertController(title: "Warning", message: "User already Exist", preferredStyle: .alert)
                
                let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alert.addAction(cancel)
                
                self.present(alert, animated: true, completion: nil)
            }
                else{
                
                let user : User = User(context: coredataUtility.managedObjectContext!)
                user.userID = UtilityClass().randomString(length: 8)
                user.loginpassword = txt_pwd.text
                user.userName = txt_user.text
                coredataUtility.saveContext()
                let alert = UIAlertController(title: "Information", message: "Registered Successfully", preferredStyle: .alert)
                
                let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alert.addAction(cancel)
                
                self.present(alert, animated: true, completion: nil)
                
                
                }
            }
            
        
        
     
        
    }
    
}
extension LoginViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
   
}

