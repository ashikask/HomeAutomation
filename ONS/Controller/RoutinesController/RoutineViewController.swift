//
//  RoutineViewController.swift
//  ONS
//
//  Created by ashika kalmady on 02/05/18.
//  Copyright © 2018 ashika kalmady. All rights reserved.
//

import UIKit

class RoutineViewController: UIViewController ,UIPopoverPresentationControllerDelegate{

    @IBOutlet weak var routineTablevIew: UITableView!
     var popoverView : AppliancePopOverTableViewController?
    let coreDataUtility : CoreDataUtility = CoreDataUtility.init()
     var routineList : [Routine] = [Routine]()
    var previousClickSame = false
    var shouldRequest = false
    
    var routineArray : [String] = [HomeAppliancesConstant.Routine.GoodMorning.rawValue,HomeAppliancesConstant.Routine.NapsTime.rawValue,HomeAppliancesConstant.Routine.YogaRoutine.rawValue,HomeAppliancesConstant.Routine.GoodNight.rawValue,HomeAppliancesConstant.Routine.FoodTime.rawValue]
    var routineImage : [String] = [HomeAppliancesConstant.RoutineImages.GoodMorning.rawValue,HomeAppliancesConstant.RoutineImages.NapsTime.rawValue,HomeAppliancesConstant.RoutineImages.YogaRoutine.rawValue,HomeAppliancesConstant.RoutineImages.GoodNight.rawValue,HomeAppliancesConstant.RoutineImages.FoodTime.rawValue]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Routines"
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor(hexString: "#F09553")]
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if  let routinesLists =  coreDataUtility.arrayOf(Routine.self){
            print(routinesLists)
            self.routineList.removeAll()
            self.routineList = routinesLists as! [Routine]
            self.routineTablevIew.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func settingsAction(_ sender: UIButton) {
        let modalViewController : MoodSettingsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MoodSettingsViewController") as! MoodSettingsViewController
        
        modalViewController.modalPresentationStyle = .overCurrentContext
        modalViewController.completionHandlers = {
            if  let routinesLists =  self.coreDataUtility.arrayOf(Routine.self){
                print(routinesLists)
                self.routineList.removeAll()
                self.routineList = routinesLists as! [Routine]
                self.routineTablevIew.reloadData()
            }
            }
        modalViewController.isFromRoutine = true
        modalViewController.rotine = self.routineList[sender.tag]
        present(modalViewController, animated: true, completion: nil)
    }
    
    @IBAction func addMoreRoutineAction(_ sender: UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        popoverView  = storyboard.instantiateViewController(withIdentifier: "AppliancePopOverTableViewController") as? AppliancePopOverTableViewController
        popoverView?.modalPresentationStyle = UIModalPresentationStyle.popover
        popoverView?.delegate = self
        popoverView?.popOverArray = routineArray
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
        let newRoutine : Routine = Routine(context: coreDataUtility.managedObjectContext!)
        
        newRoutine.routine_id = "\(HomeAppliancesConstant().routineType(forRoutine: routineArray[index]))"
        newRoutine.routine_name = routineArray[index]
        newRoutine.routine_switchstatus = "0"
        newRoutine.routineImage = routineImage[index]
        routineList =  coreDataUtility.arrayOf(Routine.self) as! [Routine]
        self.routineTablevIew.reloadData()
        coreDataUtility.saveContext()
       // Socket.soketmanager.send(message: "ROUTADD$$$\(HomeAppliancesConstant().routineType(forRoutine: routineArray[index]))")
        
    }
    func createSpinnerView() {
        let child = SpinnerViewController()
        
        // add the spinner view controller
        addChildViewController(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
        
        // wait two seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            // then remove the spinner view controller
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
    }
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        
        createSpinnerView()
        if  let roomLists =  coreDataUtility.arrayOf(Room.self){
            print(roomLists)
            let roomList : [Room] = roomLists as! [Room]
            
            var messageStream = "*"
            for (j,item) in roomList.enumerated(){
                
                if  let applianceList =  item.hasAppliance?.allObjects {
                    print(applianceList)
                    
                    
                    let appliancesFinalList : [Appliances] = applianceList as! [Appliances]
                    var routineApplianceList : [Appliances] = [Appliances]()
                    if let routineAppliance = self.routineList[sender.tag].hasAppliances?.allObjects {
                        routineApplianceList = routineAppliance as! [Appliances]
                        
                    }
                    let filteredList : [Appliances] = appliancesFinalList.filter { (object) -> Bool in
                        //return (object.applianceMoodStatus == 1)
                        return (routineApplianceList.contains(object) && (object.applianceRoutineStatus == 1))
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
                       
                        
                        
                        if sender.isOn == false {
                            if sender.tag < 8 {
                            messageStream += (j>0 && messageStream != "*") ? "@\(item.roomID!)R\(HomeAppliancesConstant().routineType(forRoutine: routineArray[sender.tag]))OF" : "\(item.roomID!)R\(HomeAppliancesConstant().routineType(forRoutine: routineArray[sender.tag]))OF"
                            }
                            else{
                                messageStream += (j>0 && messageStream != "*") ? "@\(item.roomID!)R\(HomeAppliancesConstant().routineType(forRoutine: routineArray[sender.tag]))OF" : "\(item.roomID!)R\(HomeAppliancesConstant().routineType(forRoutine: routineArray[sender.tag]))OF"
                            }
                            
                        }
                        else{
                            
                            if sender.tag < 8 {
                            messageStream += (j>0 && messageStream != "*") ? "@\(item.roomID!)R\(HomeAppliancesConstant().routineType(forRoutine: routineArray[sender.tag]))F" : "\(item.roomID!)R\(HomeAppliancesConstant().routineType(forRoutine: routineArray[sender.tag]))F"
                            }
                            else{
                               messageStream += (j>0 && messageStream != "*") ? "@\(item.roomID!)R\(HomeAppliancesConstant().routineType(forRoutine: routineArray[sender.tag]))F" : "\(item.roomID!)R\(HomeAppliancesConstant().routineType(forRoutine: routineArray[sender.tag]))F"
                            }
                            if appliancesFixed.count > 0   {
                                let variables = appliancesFixed.joined(separator: "")
                                messageStream += variables
                            }
                           
                            if appliancesVariable.count > 0 {
                                for (i,items) in appliancesVariable.enumerated(){
                                    messageStream += ",V0\(appliancesValueVariable[i])\(items)"
                                }
                            }
                             messageStream += "T"
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "HH:mm:ss"
                            let strDate = dateFormatter.string(from: self.routineList[sender.tag].startTime!).split(separator: ":")
                            let endDate = dateFormatter.string(from: self.routineList[sender.tag].endDate!).split(separator: ":")
                            
                            for item in strDate{
                                messageStream += item
                            }
                            messageStream += ","
                            for item in endDate{
                                messageStream += item
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
           
                Socket.soketmanager.send(message: messageStream)
                let mood = self.routineList[sender.tag]
                mood.routine_switchstatus = (sender.isOn == true) ? "1" : "0"
            
            coreDataUtility.saveContext()
            print(messageStream)
            //sharedManager.shared.previousRoutine = self.routineList[sender.tag]
        }
        
        
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
extension RoutineViewController : AppliancePopOverProtocol{
    
    func didSelectItem(index: Int) {
        popoverView?.dismiss(animated: true, completion: nil)
        self.addNewMood(index: index)
    
    }
}
extension RoutineViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routineList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : RoutineTableViewCell = self.routineTablevIew.dequeueReusableCell(withIdentifier: "routineCell", for: indexPath) as! RoutineTableViewCell
        
        cell.routineName.text = self.routineList[indexPath.row].routine_name
        cell.routineButton.tag = indexPath.row
        cell.routineSwitch.tag = indexPath.row
        cell.routineSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: UIControlEvents.valueChanged)
        
         if let image = routineList[indexPath.row].routineImage {
        cell.routineImage.image = UIImage(named: image)
        }
        if routineList[indexPath.row].routine_switchstatus == "1"{
            cell.routineSwitch.isOn = true
        }
        else{
            cell.routineSwitch.isOn = false
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        if let sTime = self.routineList[indexPath.row].startTime{
        let strDate = dateFormatter.string(from: sTime)
            
                cell.routineTime.text = strDate 
            
        cell.routineTime.isHidden = false
        }
        else{
            cell.routineTime.isHidden = true
        }
        
        
        cell.routineButton.addTarget(self, action: #selector(settingsAction(_:)), for: .touchUpInside)
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
