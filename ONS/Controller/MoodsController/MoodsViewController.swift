//
//  MoodsViewController.swift
//  ONS
//
//  Created by ashika kalmady on 02/05/18.
//  Copyright © 2018 ashika kalmady. All rights reserved.
//

import UIKit
import CoreData

class MoodsViewController: UIViewController ,UIPopoverPresentationControllerDelegate , SocketStreamDelegate{

    @IBOutlet weak var moodsTableView: UITableView!
    var popoverView : AppliancePopOverTableViewController?
    let coreDataUtility : CoreDataUtility = CoreDataUtility.init()
     var moodsList : [Mood] = [Mood]()
    var previousClickSame = false
    var shouldRequest = false
    //initialization
    let moodArray : NSMutableArray = [HomeAppliancesConstant.Moods.ChillOut.rawValue,HomeAppliancesConstant.Moods.LeavingHome.rawValue,HomeAppliancesConstant.Moods.MovieNight.rawValue,HomeAppliancesConstant.Moods.Party.rawValue,HomeAppliancesConstant.Moods.Reading.rawValue,HomeAppliancesConstant.Moods.Working.rawValue]
     let moodImages : NSMutableArray = [HomeAppliancesConstant.MoodImages.ChillOut.rawValue,HomeAppliancesConstant.MoodImages.LeavingHome.rawValue,HomeAppliancesConstant.MoodImages.MovieNight.rawValue,HomeAppliancesConstant.MoodImages.Party.rawValue,HomeAppliancesConstant.MoodImages.Reading.rawValue,HomeAppliancesConstant.MoodImages.Working.rawValue]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.navigationItem.title = "Moods"
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor(hexString: "#F09553")]
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if  let moodLists =  coreDataUtility.arrayOf(Mood.self){
            print(moodLists)
            self.moodsList.removeAll()
            self.moodsList = moodLists as! [Mood]
            self.moodsTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Action
    @IBAction func settingsAction(_ sender: UIButton) {
        let modalViewController : MoodSettingsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MoodSettingsViewController") as! MoodSettingsViewController
        modalViewController.modalPresentationStyle = .overCurrentContext
         modalViewController.isFromRoutine = false
        modalViewController.mood = self.moodsList[sender.tag]
        present(modalViewController, animated: true, completion: nil)
    }

    @IBAction func addMoreMoodAction(_ sender: UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        popoverView  = storyboard.instantiateViewController(withIdentifier: "AppliancePopOverTableViewController") as? AppliancePopOverTableViewController
        popoverView?.modalPresentationStyle = UIModalPresentationStyle.popover
        popoverView?.delegate = self
        popoverView?.popOverArray = moodArray as! [String]
        let popover: UIPopoverPresentationController = popoverView!.popoverPresentationController!
        popover.delegate = self
        popover.permittedArrowDirections = .up
        popover.sourceView = sender
        popover.sourceRect = sender.bounds
        
        present(popoverView!, animated: true, completion:nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    // MARK: - Custom Method
    func addNewMood(index: Int){
        let newMood : Mood = Mood(context: coreDataUtility.managedObjectContext!)
        
        newMood.moodId = "\(HomeAppliancesConstant().moodType(forMood: (moodArray[index] as? String)!))"
        newMood.moodName = moodArray[index] as? String
        newMood.imageId = moodImages[index] as? String
        newMood.isAdded = 0
        coreDataUtility.saveContext()
        
        Socket.soketmanager.send(message: "MOODADD$$$\(HomeAppliancesConstant().moodType(forMood: (moodArray[index] as? String)!))")
        moodsList =  coreDataUtility.arrayOf(Mood.self) as! [Mood]
        self.moodsTableView.reloadData()
        
    }
     @IBAction func switchValueChanged(_ sender: UISwitch) {
      
      
        if  let roomLists =  coreDataUtility.arrayOf(Room.self){
            print(roomLists)
            let roomList : [Room] = roomLists as! [Room]
           
             var messageStream = "*"
            for (j,item) in roomList.enumerated(){
               
            if  let applianceList =  item.hasAppliance?.allObjects {
                print(applianceList)
                
                let appliancesFinalList : [Appliances] = applianceList as! [Appliances]
                var moodApplianceList : [Appliances] = [Appliances]()
                if let moodAppliance = self.moodsList[sender.tag].hasAppliances?.allObjects {
                     moodApplianceList = moodAppliance as! [Appliances]
                }
                
                let filteredList : [Appliances] = appliancesFinalList.filter { (object) -> Bool in
                    //return (object.applianceMoodStatus == 1)
                    return (moodApplianceList.contains(object) && (object.applianceMoodStatus == 1))
                }
                
                var appliancesFixed : [String] = [String]()
                var appliancesVariable : [String] = [String]()
                var appliancesValueVariable : [Int] = [Int]()
                if filteredList.count > 0 {
                    
                    appliancesFixed = filteredList.filter { (object) -> Bool in
                        return (object.applianceType! == "F")
                        }.map { (object) -> String in
                            return object.applianceDisplayName!
                    }
                    print(appliancesFixed)
                    appliancesVariable = filteredList.filter { (object) -> Bool in
                        return (object.applianceType! == "V")
                        }.map { (object) -> String in
                            return object.applianceDisplayName!
                    }
                    print(appliancesVariable)
                    appliancesValueVariable = filteredList.filter { (object) -> Bool in
                        return (object.applianceType! == "V")
                        }.map { (object) -> Int in
                            return Int(object.applianceVariableCount)
                    }
                    print(appliancesValueVariable)
                }
                if appliancesFixed.count > 0 || appliancesVariable.count > 0 {
                     previousClickSame = false
                    if let moodObject = sharedManager.shared.previousMood {
                        if moodObject.isEqual(self.moodsList[sender.tag]){
                            previousClickSame = true
                        }
                        else{
                            
                            previousClickSame = false
                            
                        }
                    }
                    
                    
                    if sender.isOn == false &&  previousClickSame{
                        messageStream += (j>0) ? "@\(item.roomID!)M\(HomeAppliancesConstant().moodType(forMood: (moodArray[sender.tag] as? String)!))FOF" : "\(item.roomID!)M$$FOF"
                        if appliancesFixed.count > 0   {
                            let variables = appliancesFixed.joined(separator: "")
                            messageStream += variables
                        }
                        if appliancesVariable.count > 0 {
                            for items in appliancesVariable{
                                messageStream += ",V00\(items)"
                            }
                        }
                    
                
                }
                    else{
                        if sender.isOn == false {
                        sender.isOn = true
                            shouldRequest = false
                        }
                        else{
                        shouldRequest = true
                        }
                        messageStream += (j>0) ? "@\(item.roomID!)M\(HomeAppliancesConstant().moodType(forMood: (moodArray[sender.tag] as? String)!))FON" : "\(item.roomID!)M\(HomeAppliancesConstant().moodType(forMood: (moodArray[sender.tag] as? String)!))FON"
                        if appliancesFixed.count > 0   {
                            let variables = appliancesFixed.joined(separator: "")
                            messageStream += variables
                        }
                        if appliancesVariable.count > 0 {
                            for (i,items) in appliancesVariable.enumerated(){
                                messageStream += ",V0\(appliancesValueVariable[i])\(items)"
                            }
                        }
                    }
                }
                
                for applianceFiltered in filteredList {
                    if sender.isOn {
                     applianceFiltered.applianceStatus = 1
                    }
                    else{
                         applianceFiltered.applianceStatus = 0
                    }
                    coreDataUtility.saveContext()
                }
                
            }
               
            }
             messageStream += "#"
            if shouldRequest {
            Socket.soketmanager.send(message: messageStream)
            let mood = self.moodsList[sender.tag]
            mood.isAdded = (sender.isOn == true) ? 1 : 0
            }
            coreDataUtility.saveContext()
            print(messageStream)
            sharedManager.shared.previousMood = self.moodsList[sender.tag]
        }
        
    
    }
    /*
    // MARK: - Navigation

    
    */
    func socketDidConnect(stream: Stream) {
        
    }
    func socketDidReceiveMessage(stream: Stream, message: String) {
        if message.count > 0 {
            
            
            DispatchQueue.main.async {
                CoreDataUtility().receivedMessage(message: message)
                let applianceId = String(message.suffix(2).dropLast())
                
                let index = message.index(message.startIndex, offsetBy: 22)
                let status = String(message[index])
                
                let indexVariable = message.index(message.startIndex, offsetBy: 20)
                let variable = String(message[indexVariable])
                
                
                if variable == "F"{
                    
                }
                else{
                    if applianceId == "7"{
                        
                    }
                    else{
                        
                        if status == "0" {
                            
                        }
                        else{
                            
                        }
                        
                        
                        
                    }
                    
                }
                
            }
            
        }
        
    }

}
extension MoodsViewController : AppliancePopOverProtocol{
    
    func didSelectItem(index: Int) {
        popoverView?.dismiss(animated: true, completion: nil)
        self.addNewMood(index: index)
        
        
    }
}
extension MoodsViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moodsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MoodsTableViewCell = self.moodsTableView.dequeueReusableCell(withIdentifier: "moodsCell", for: indexPath) as! MoodsTableViewCell
         if let image = moodsList[indexPath.row].imageId {
        cell.moodsImage.image = UIImage(named: image)
        }
        cell.moodsButton.tag = indexPath.row 
        cell.moodsButton.addTarget(self, action: #selector(settingsAction(_:)), for: .touchUpInside)
        cell.moodsSwitch.tag = indexPath.row
        cell.moodsSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: UIControlEvents.valueChanged)
        if moodsList[indexPath.row].isAdded == 1 {
            cell.moodsSwitch.isOn = true
        }
        else{
            cell.moodsSwitch.isOn = false
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        
    }
}
