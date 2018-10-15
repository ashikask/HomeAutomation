//
//  AddUpdateRoomViewController.swift
//  ONS
//
//  Created by ashika kalmady on 03/05/18.
//  Copyright © 2018 ashika kalmady. All rights reserved.
//

import UIKit


protocol AddUpdateRoomProtocol {
    func dissmissView()
    func addData(roomName : String, roomId: String, roomImage: String)
    func updateData(oldRoomId : String, newRoomId: String)
    func addappliance(forAppliance: String , applianceName: String, applianceImage: String)
}
class AddUpdateRoomViewController: UIViewController , UIPopoverPresentationControllerDelegate{

    @IBOutlet weak var newRoomIdLabel: UITextField!
    @IBOutlet weak var oldroomIdLabel: UILabel!
    @IBOutlet weak var enterRoomIdTextField: UITextField!
    @IBOutlet weak var selectRommTextField: UITextField!
    @IBOutlet weak var updateRoom: UIView!
    @IBOutlet weak var addNewRoom: UIView!
    var selectedRoom : Room?
    var isUpdate : Bool = false
    var isForAppliance : Bool = false
    var delegate : AddUpdateRoomProtocol?
    var popoverView : AppliancePopOverTableViewController?
    var popoverViewAppliance : AppliancePopOverTableViewController?
    @IBOutlet weak var applianceName: UITextField!
    @IBOutlet weak var addNewAppliance: UIView!
    @IBOutlet weak var applianceButton: UIButton!
    
    let roomArray = [HomeAppliancesConstant.Rooms.StudyRoom.rawValue, HomeAppliancesConstant.Rooms.BedRoom.rawValue,HomeAppliancesConstant.Rooms.Kitchen.rawValue,HomeAppliancesConstant.Rooms.LivingRoom.rawValue,HomeAppliancesConstant.Rooms.MasterBedRoom.rawValue]
    let appliancesArray = [HomeAppliancesConstant.Appliances.BedLamp.rawValue, HomeAppliancesConstant.Appliances.Bulb.rawValue,HomeAppliancesConstant.Appliances.DimmableLight.rawValue,HomeAppliancesConstant.Appliances.GateBulb.rawValue,HomeAppliancesConstant.Appliances.Fan.rawValue,HomeAppliancesConstant.Appliances.StudyLam.rawValue,HomeAppliancesConstant.Appliances.TV.rawValue,HomeAppliancesConstant.Appliances.DimmableLight.rawValue]
    
   let homeApplianceConstatnt = HomeAppliancesConstant()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        if isForAppliance{
            self.updateRoom.isHidden = isForAppliance
            self.addNewRoom.isHidden = isForAppliance
            self.addNewAppliance.isHidden = !isForAppliance
            
            self.applianceButton.setTitle(appliancesArray[0], for: .normal)
        }
        else{
            self.addNewAppliance.isHidden = !isForAppliance
            self.updateRoom.isHidden = !isUpdate
            self.addNewRoom.isHidden = isUpdate
        }
        if isUpdate {
            oldroomIdLabel.text = selectedRoom?.roomID
        }
        
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - ButtonAction
    @IBAction func DismisssviewAction(_ sender: UIButton) {
        self.delegate?.dissmissView()
    }
    @IBAction func addApplianceAction(_ sender: Any) {
        if ((applianceName.text?.count)! > 0 ){
            self.delegate?.addappliance(forAppliance: (self.applianceButton.titleLabel?.text)!, applianceName: self.applianceName.text!, applianceImage: homeApplianceConstatnt.appliance(applianceName: (self.applianceButton.titleLabel?.text)!))
            self.delegate?.dissmissView()
        }
        else{
            let refreshAlert = UIAlertController(title: "Alert", message: "Please enter all data", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func addRoomAction(_ sender: UIButton) {
        
        if ((selectRommTextField.text?.count)! > 0 || (enterRoomIdTextField.text?.count)! > 0) {
            
            self.delegate?.addData(roomName: selectRommTextField.text!, roomId: enterRoomIdTextField.text!, roomImage: homeApplianceConstatnt.room(roomName: selectRommTextField.text!))
                                  
            self.delegate?.dissmissView()
        }
        else{
            let refreshAlert = UIAlertController(title: "Alert", message: "Please enter all data", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func listRoomTapped(_ sender: UIButton) {
        
        self.showAppliancesList(onView: sender)
    }
    @IBAction func UpdateButtonAction(_ sender: UIButton) {
         if ((newRoomIdLabel.text?.count)! > 0 ){
            self.delegate?.updateData(oldRoomId: (selectedRoom?.r_id)!, newRoomId: newRoomIdLabel.text!)
            self.delegate?.dissmissView()
        }
         else{
            let refreshAlert = UIAlertController(title: "Alert", message: "Please enter all data", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(refreshAlert, animated: true, completion: nil)
        }
        
    }
    // MARK: - Custom Method
    func showRoomList(onView: UITextField){
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        popoverView  = storyboard.instantiateViewController(withIdentifier: "AppliancePopOverTableViewController") as? AppliancePopOverTableViewController
        popoverView?.modalPresentationStyle = UIModalPresentationStyle.popover
        popoverView?.delegate = self
        popoverView?.popOverArray = roomArray
        let popover: UIPopoverPresentationController = popoverView!.popoverPresentationController!
        popover.delegate = self
        popover.permittedArrowDirections = .up
        popover.sourceView = onView
        popover.sourceRect = onView.bounds
    
        present(popoverView!, animated: true, completion:nil)
    }
    
    func showAppliancesList(onView: UIButton){
       let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        popoverViewAppliance  = storyboard.instantiateViewController(withIdentifier: "AppliancePopOverTableViewController") as? AppliancePopOverTableViewController
        popoverViewAppliance?.modalPresentationStyle = UIModalPresentationStyle.popover
        popoverViewAppliance?.delegate = self
        popoverViewAppliance?.popOverArray = appliancesArray
        let popover: UIPopoverPresentationController = popoverViewAppliance!.popoverPresentationController!
        popover.delegate = self
        popover.permittedArrowDirections = .up
        popover.sourceView = onView
        popover.sourceRect = onView.bounds 
        
        present(popoverViewAppliance!, animated: true, completion:nil)
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

extension AddUpdateRoomViewController : AppliancePopOverProtocol{
    
    func didSelectItem(index: Int) {
        if let popView = popoverView{
            popView.dismiss(animated: true, completion: nil)
            selectRommTextField.text = self.roomArray[index]
        }
        else{
            popoverViewAppliance?.dismiss(animated: true, completion: nil)
            self.applianceButton.setTitle(appliancesArray[index], for: .normal)
        }
    }
}

extension AddUpdateRoomViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
         self.view.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField.tag == 1
    {
            textField.resignFirstResponder()
            self.view.endEditing(true)
            showRoomList(onView: textField)
     
        return false
        }
         return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField.tag == 1
        {
            textField.resignFirstResponder()
        }
    }
}

