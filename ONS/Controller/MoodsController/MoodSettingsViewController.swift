//
//  MoodSettingsViewController.swift
//  ONS
//
//  Created by ashika kalmady on 03/05/18.
//  Copyright © 2018 ashika kalmady. All rights reserved.
//

import UIKit
import CoreData

protocol MoodRoutineSettingsProtocol {
    func dismissView()
}
class MoodSettingsViewController: UIViewController , UIPopoverPresentationControllerDelegate{
    
    

    @IBOutlet weak var EndTimeTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var moodRoutinetAbleview: UITableView!
    
    @IBOutlet weak var roomListButton: UIButton!
    @IBOutlet weak var routineStackView: UIStackView!
    var roomList : [Room] = [Room]()
    var selectedIndex : Int = 0
    let coredataUtility : CoreDataUtility = CoreDataUtility.init()
    var appliancesList : [Appliances] = [Appliances]()
    var filteredAppliancesList : [Appliances] = [Appliances]()
    var isFromRoutine : Bool = false
    var popoverViewAppliance : AppliancePopOverTableViewController?
    let datePicker = UIDatePicker()
    let datePickerEnd = UIDatePicker()
    var isStartTimeSet : Bool = false
    var isEndTimeSet : Bool = false
    var activeTextField :UITextField?
    var rotine : Routine?
    var mood : Mood?
    var completionHandlers: () -> Void = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.routineStackView.isHidden = !isFromRoutine
        if  let roomLists =  coredataUtility.arrayOf(Room.self){
            print(roomLists)
            self.roomList = roomLists as! [Room]
            self.roomListButton.setTitle(roomList[0].roomName, for: .normal)
            self.getAppliances(index: 0)
        }
        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        datePickerEnd.datePickerMode = UIDatePickerMode.dateAndTime
        startTimeTextField.inputView = datePicker
        EndTimeTextField.inputView = datePickerEnd
        datePicker.addTarget(self, action: #selector(datePickerChanged(datePicker:)), for: UIControlEvents.valueChanged)
        datePickerEnd.addTarget(self, action: #selector(datePickerChangedEnd(datePicker:)), for: UIControlEvents.valueChanged)
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(dismissPicker))
        self.filteredAppliancesList.removeAll()
        startTimeTextField.inputAccessoryView = toolBar
        EndTimeTextField.inputAccessoryView = toolBar
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Action
    @IBAction func selectRoomAction(_ sender: UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        popoverViewAppliance  = storyboard.instantiateViewController(withIdentifier: "AppliancePopOverTableViewController") as? AppliancePopOverTableViewController
        popoverViewAppliance?.modalPresentationStyle = UIModalPresentationStyle.popover
        popoverViewAppliance?.delegate = self
        popoverViewAppliance?.popOverArray = roomList.map({ (room) -> String in
            return room.roomName!
        })
        let popover: UIPopoverPresentationController = popoverViewAppliance!.popoverPresentationController!
        popover.delegate = self
        popover.permittedArrowDirections = .up
        popover.sourceView = sender
        popover.sourceRect = sender.bounds
        
        present(popoverViewAppliance!, animated: true, completion:nil)
    }
    
    @IBAction func saveButtonAction(_ sender: UIBarButtonItem) {
        
        if isFromRoutine{
            
            if (startTimeTextField.text?.count)! > 0 && (EndTimeTextField.text?.count)! > 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss" //Your date format
            
            self.rotine?.startTime = dateFormatter.date(from: startTimeTextField.text!)
            self.rotine?.endDate = dateFormatter.date(from: EndTimeTextField.text!)
                
                for item in self.filteredAppliancesList{
                    if item.applianceRoutineStatus == 1 {
                        self.rotine?.addToHasAppliances(item)
                    }
                    else{
                        if let routineAppliance = rotine?.hasAppliances?.allObjects {
                            let routineApplianceList = routineAppliance as! [Appliances]
                            for rotine in routineApplianceList{
                                if rotine.applianceId == item.applianceId {
                                    self.rotine?.removeFromHasAppliances(rotine)
                                    
                                }
                            }
                        }
                    }
                }
            coredataUtility.saveContext()
                self.dismiss(animated: true) {
                    self.completionHandlers()
                }
            }
            else{
                let refreshAlert = UIAlertController(title: "Alert", message: "Please enter all data", preferredStyle: UIAlertControllerStyle.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                present(refreshAlert, animated: true, completion: nil)
            }
            
        }
        else {
            
            
            for item in self.filteredAppliancesList{
                if item.applianceMoodStatus == 1 {
                    self.mood?.addToHasAppliances(item)
                }
                else{
                    if let moodAppliance = mood?.hasAppliances?.allObjects {
                        let moodApplianceList = moodAppliance as! [Appliances]
                        for mood in moodApplianceList{
                            if mood.applianceId == item.applianceId {
                                
                                self.mood?.removeFromHasAppliances(mood)
                            }
                        }
                    }
                }
            }
            
 
            coredataUtility.saveContext()
            
        }
          self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func getAppliances(index : Int){
       
            if let applianceList =  self.roomList[index].hasAppliance?.allObjects {
                print(applianceList)
                 self.appliancesList.removeAll()
               // self.filteredAppliancesList.removeAll()
                self.appliancesList = applianceList as! [Appliances]
                for item in self.appliancesList{
                    if  isFromRoutine{
                        if let moodAppliance = self.rotine?.hasAppliances?.allObjects as? [Appliances]{
                            let filteredList : [Appliances] = moodAppliance.filter { (object) -> Bool in
                                //return (object.applianceMoodStatus == 1)
                                return (object == item)
                            }
                            if filteredList.count > 0 {
                                    if filteredList[0].applianceRoutineStatus == 1 {
                                        self.filteredAppliancesList.append(filteredList[0])
                                    }
                            }
                        }
                    }
                    else{
                        if let moodAppliance = self.mood?.hasAppliances?.allObjects as? [Appliances]{
                            let filteredList : [Appliances] = moodAppliance.filter { (object) -> Bool in
                                //return (object.applianceMoodStatus == 1)
                                return (object == item)
                            }
                            if filteredList.count > 0 {
                                    if filteredList[0].applianceMoodStatus == 1 {
                                        self.filteredAppliancesList.append(filteredList[0])
                                    }
                            }
                        }
                        
                    }
                    
                   
                    
                }
                
            }
            
            self.moodRoutinetAbleview.reloadData()
        
    }
    
    @objc func dismissPicker() {
        if activeTextField == startTimeTextField{
        if isStartTimeSet == false  {
        print(datePicker.date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            let strDate = dateFormatter.string(from: datePicker.date)
            startTimeTextField.text = strDate
        }
        else {
            isStartTimeSet = false
        }
        }
        else {
        if isEndTimeSet == false{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            let endDate = dateFormatter.string(from: datePicker.date)
            
            EndTimeTextField.text = endDate
        }
        else{
            
            isEndTimeSet = false
        }
        }
        view.endEditing(true)
        
    }
    
    func someEntityExists(id: Int) -> Bool {
        let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "mood")
        fetchRequest.predicate = NSPredicate(format: "someField = %d", id)

        fetchRequest.includesSubentities = false
        
        var entitiesCount = 0
        
        do {
            entitiesCount = (try coredataUtility.managedObjectContext?.count(for: fetchRequest))!
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return entitiesCount > 0
    }
    
    @IBAction func valueChangeSwitch(_ sender: UISwitch) {
        if sender.isOn == true {
            
            let applianceObj = self.appliancesList[sender.tag]
            if isFromRoutine{
               applianceObj.applianceRoutineStatus = 1
             //   self.rotine?.addToHasAppliances(self.appliancesList[sender.tag])
               
            }
            else{
             // self.mood?.addToHasAppliances(self.appliancesList[sender.tag])
                applianceObj.applianceMoodStatus = 1
            }
            if applianceObj.applianceType == "V" {
                let modalViewController : RoomAppliancesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RoomAppliancesViewController") as! RoomAppliancesViewController
                modalViewController.delegate = self
             //   modalViewController.roomSelected = roomList[sender.tag]
                modalViewController.applianceSelected = applianceObj
                modalViewController.isFromMoodRoutineSettings = true
                modalViewController.modalPresentationStyle = .overCurrentContext
                present(modalViewController, animated: true, completion: nil)
            }
            //coredataUtility.saveContext()
            self.filteredAppliancesList.append(self.appliancesList[sender.tag])
            
            
            
        }
        else{
            if self.filteredAppliancesList.contains(self.appliancesList[sender.tag]){
                //let inexV = self.filteredAppliancesList.index(of: self.appliancesList[sender.tag])
                let applianceObj = self.appliancesList[sender.tag]
                
                if isFromRoutine{
                    applianceObj.applianceRoutineStatus = 0
//                    if let routineAppliance = rotine?.hasAppliances?.allObjects {
//                        let routineApplianceList = routineAppliance as! [Appliances]
//                        for item in routineApplianceList{
//                            if item.applianceId == applianceObj.applianceId {
//                                self.rotine?.removeFromHasAppliances(item)
//
//                            }
//                        }
//                    }
                }
                else{
                    
                    applianceObj.applianceMoodStatus = 0
//                    if let moodAppliance = mood?.hasAppliances?.allObjects {
//                        let moodApplianceList = moodAppliance as! [Appliances]
//                        for item in moodApplianceList{
//                            if item.applianceId == applianceObj.applianceId {
//                                
//                                self.mood?.removeFromHasAppliances(item)
//                            }
//                        }
//                    }
                }
              //  coredataUtility.saveContext()
                self.filteredAppliancesList.append(self.appliancesList[sender.tag])
             //   self.filteredAppliancesList.remove(at: inexV!)
                
            }
        }
         coredataUtility.saveContext()
    }
    
    @objc func datePickerChanged(datePicker:UIDatePicker) {
       isStartTimeSet = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let strDate = dateFormatter.string(from: datePicker.date)
        
        startTimeTextField.text = strDate
    }
    @objc func datePickerChangedEnd(datePicker:UIDatePicker) {
        isEndTimeSet = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let endDate = dateFormatter.string(from: datePicker.date)
        
        EndTimeTextField.text = endDate
    }
    // MARK: - Popover
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
extension MoodSettingsViewController : AppliancePopOverProtocol{
    
    func didSelectItem(index: Int) {
       
            popoverViewAppliance?.dismiss(animated: true, completion: nil)
            self.roomListButton.setTitle(roomList[index].roomName, for: .normal)
            self.selectedIndex = index
            self.getAppliances(index: index)
    }
}
extension UIToolbar {
    
    func ToolbarPiker(mySelect : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
}
extension MoodSettingsViewController : UITextFieldDelegate{

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        activeTextField = textField
        return true
    }

}

extension MoodSettingsViewController : RoomAppliancesProtocol{
    
    func dissmissView() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension MoodSettingsViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appliancesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MoodSettingsTableViewCell = self.moodRoutinetAbleview.dequeueReusableCell(withIdentifier: "moodsettingsCell", for: indexPath) as! MoodSettingsTableViewCell
        cell.moodSettingsAppliance.text = self.appliancesList[indexPath.row].applianceName
        cell.moodApplianceSubName.text = self.appliancesList[indexPath.row].applianceName! + self.appliancesList[indexPath.row].applianceDisplayName!
        if let image = self.appliancesList[indexPath.row].imageId {
            cell.moodSettingsImageView.image = UIImage(named: image)
        }
        cell.moodApplianceSwitch.tag = indexPath.row
        if isFromRoutine{
        cell.moodApplianceSwitch.isOn = self.appliancesList[indexPath.row].applianceRoutineStatus == 1 ? true : false
            
            var status : Bool = false;
            if let moodAppliance = rotine?.hasAppliances?.allObjects {
                let moodApplianceList = moodAppliance as! [Appliances]
                for item in moodApplianceList{
                    if item.applianceId == self.appliancesList[indexPath.row].applianceId {
                        status =  item.applianceRoutineStatus == 1 ? true : false
                        break
                    }
                }
            }
            cell.moodApplianceSwitch.isOn =  status
            if let satrttime = rotine?.startTime{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss"
                let strDate = dateFormatter.string(from: satrttime)
                
                startTimeTextField.text = strDate
            }
            if let endtime = rotine?.endDate{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss"
                let strDate = dateFormatter.string(from: endtime)
                
                EndTimeTextField.text = strDate
            }
            
        }
        else{
            var status : Bool = false;
            if let moodAppliance = mood?.hasAppliances?.allObjects {
                let moodApplianceList = moodAppliance as! [Appliances]
                for item in moodApplianceList{
                    if item.applianceId == self.appliancesList[indexPath.row].applianceId {
                        status =  item.applianceMoodStatus == 1 ? true : false
                        break
                    }
                }
            }
            cell.moodApplianceSwitch.isOn =  status
        }
        cell.moodApplianceSwitch.addTarget(self, action: #selector(valueChangeSwitch(_:)), for: UIControlEvents.valueChanged)
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
