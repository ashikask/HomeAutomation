//
//  AppliancesViewController.swift
//  ONS
//
//  Created by ashika kalmady on 02/05/18.
//  Copyright © 2018 ashika kalmady. All rights reserved.
//

import UIKit
import CoreData

class AppliancesClass{
    var applianceName : String
    var imageName : String
    init(name: String, image : String) {
        self.applianceName = name
        self.imageName = image
    }
}
class AppliancesViewController: UIViewController, UIPopoverPresentationControllerDelegate , SocketStreamDelegate{
  
    @IBOutlet weak var appliancesTable: UITableView!
    var appliancesList : [Appliances] = [Appliances]()
    let coredataUtility : CoreDataUtility = CoreDataUtility.init()
    var popoverView : AppliancePopOverTableViewController?
    var appliancesClassList : [AppliancesClass] = [AppliancesClass]()
    let child = SpinnerViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        Socket.soketmanager.delegate = self
         createSpinnerView()
       self.appliancesTable.separatorStyle = .none
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        //set image for button
        button.setImage(UIImage(named: "UserSetting"), for: UIControlState.normal)
        //add function for button
        button.addTarget(self, action: #selector(popOverButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        
        //set frame
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Appliances"
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor(hexString: "#F09553")]
        navigationController?.navigationBar.barTintColor = UIColor.lightGray
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       updateUi()
       
        btDiscoverySharedInstance.disconnect()
    }

    func updateUi(){
        if  let applianceList =  coredataUtility.arrayOf(Appliances.self){
            print(applianceList)
            self.appliancesList = applianceList as! [Appliances]
            
            for item in self.appliancesList{
                
                if !appliancesClassList.contains(where: {
                    $0.applianceName == item.applianceName!
                }){
                    appliancesClassList.append(AppliancesClass(name: item.applianceName!, image: item.imageId!))
                }
            }
            for item in self.appliancesClassList{
                
                
                if !self.appliancesList.contains(where: { (appliance) -> Bool in
                    appliance.applianceName == item.applianceName
                }){
                    appliancesClassList.removeAll { (applianceObj) -> Bool in
                        applianceObj.applianceName == item.applianceName
                    }
                }
                
            }
        }
        else{
            self.appliancesClassList.removeAll()
            self.appliancesList.removeAll()
        }
        self.appliancesTable.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //return attributed string with last character marked as red
    func returnAttributedString(attributeString : NSString) -> NSMutableAttributedString {
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: attributeString as String, attributes: [NSAttributedStringKey.font: UIFont.init(name: "Gill Sans", size: 20)!,
                                                                                                    NSAttributedStringKey.foregroundColor: UIColor.black])
        //F09553
        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(hexString: "#F09553"), range: NSRange(location:0,length:1))
        return myMutableString
    }
    
    
    // MARK: - Button Action
    
    @IBAction func popOverButtonTapped(_ sender: UIButton) {
        //print("hello")
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        popoverView = storyboard.instantiateViewController(withIdentifier: "AppliancePopOverTableViewController") as? AppliancePopOverTableViewController
        popoverView?.modalPresentationStyle = UIModalPresentationStyle.popover
        popoverView?.delegate = self
        popoverView?.popOverArray = ["Rooms", "Moods", "Routines", "Mood Lighting", "Communication","Clock Settings"]
        let popover: UIPopoverPresentationController = popoverView!.popoverPresentationController!
        popover.delegate = self
        popover.permittedArrowDirections = .up
        popover.sourceView = sender
        popover.sourceRect = sender.bounds
       
        self.present(popoverView!, animated: true, completion:nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AppliancesViewController : AppliancePopOverProtocol{

    func didSelectItem(index: Int) {
    popoverView!.dismiss(animated: true, completion: nil)
        switch index {
        case 0:
            let viewController : RoomsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RoomsViewController") as! RoomsViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        case 1:
            let viewController : MoodsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MoodsViewController") as! MoodsViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        case 2:
            let viewController : RoutineViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RoutineViewController") as! RoutineViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        case 3:
            let viewController : MoodsLightViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MoodsLightViewController") as! MoodsLightViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        case 4:
            let viewController : ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.present(viewController, animated: true, completion: nil)
        case 5:
            let viewController : SettingsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
            self.present(viewController, animated: true, completion: nil)
        default:
            break
        }
    }
    func createSpinnerView() {
        
        
        // add the spinner view controller
        addChildViewController(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
        
       
    }
    func socketDidConnect(stream: Stream) {
        
    }
    
    func socketDidReceiveBeginMessage(stream: Stream, message: String) {
        DispatchQueue.main.async {
            CoreDataUtility().receivedMessage(message: message as String)
            self.updateUi()
            self.child.willMove(toParentViewController: nil)
            self.child.view.removeFromSuperview()
            self.child.removeFromParentViewController()
        }
    }
}
extension AppliancesViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appliancesClassList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ApplianceTableViewCell = self.appliancesTable.dequeueReusableCell(withIdentifier: "appliancesCell", for: indexPath) as! ApplianceTableViewCell
        cell.applianceName.text = appliancesClassList[indexPath.row].applianceName
        cell.applianceImage.image = UIImage(named: appliancesClassList[indexPath.row].imageName)
        
        let predicateTotal = NSPredicate(format: "applianceName = %@", appliancesClassList[indexPath.row].applianceName)
         if  let appliancesTotalList =  coredataUtility.arrayOf(Appliances.self, predicate: predicateTotal, sortDescriptor: nil){
           let predicate = NSPredicate(format: "applianceName = %@ AND applianceStatus = %i", appliancesClassList[indexPath.row].applianceName, 1)
          
             if  let appliancesList =  coredataUtility.arrayOf(Appliances.self, predicate: predicate, sortDescriptor: nil){
                
               cell.applianceCount.text = "\(appliancesList.count) / \(appliancesTotalList.count)"
                cell.applianceCount.attributedText = self.returnAttributedString(attributeString: cell.applianceCount.text! as NSString)
            }
             else{
                cell.applianceCount.text = "\(0) / \(appliancesTotalList.count)"
                cell.applianceCount.attributedText = self.returnAttributedString(attributeString: cell.applianceCount.text! as NSString)
            }
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    
    
}
