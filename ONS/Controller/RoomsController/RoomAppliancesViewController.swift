//
//  RoomAppliancesViewController.swift
//  ONS
//
//  Created by ashika kalmady on 03/05/18.
//  Copyright © 2018 ashika kalmady. All rights reserved.
//

import UIKit
protocol RoomAppliancesProtocol {
    func dissmissView()
}
class RoomAppliancesViewController: UIViewController , SocketStreamDelegate{
    
    @IBOutlet weak var sliderStep: UISlider!
    @IBOutlet weak var stepperView: UIView!
    @IBOutlet var addCornerView: UIView!
    @IBOutlet var addcornerView: UIView!
    @IBOutlet weak var variableApplianceSwitch: UISwitch!
    @IBOutlet weak var variableApplianceName: UILabel!
    @IBOutlet weak var variableAppianceView: UIView!
    @IBOutlet weak var circularSlider: CircularSlider!
    
    @IBOutlet weak var roomApplianceCollectionView: UICollectionView!
    
    @IBOutlet weak var applianceListView: UIView!
    @IBOutlet weak var heightVaryForView: NSLayoutConstraint!
    var delegate : RoomAppliancesProtocol?
    var roomSelected : Room?
    var applianceSelected : Appliances = Appliances()
    var appliancesList : [Appliances] = [Appliances]()
    var index : Int?
    let coredataUtility : CoreDataUtility = CoreDataUtility.init()
    var isFirstLaunch : Bool = false
    var previousValue : Int = 0
    @IBOutlet var roomImage: UIImageView!
    @IBOutlet var roomName: UILabel!
    var isFromMoodRoutineSettings : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        variableAppianceView.isHidden = true
        applianceListView.isHidden = false
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        Socket.soketmanager.delegate = self
        getAppliances()
        
        variableAppianceView.layer.borderWidth = 2
        variableAppianceView.layer.borderColor = UIColor(hexString: "#F09553").cgColor
        variableAppianceView.layer.cornerRadius = 10
          addcornerView.layer.cornerRadius = 10
        addCornerView.layer.cornerRadius = 10
        applianceListView.layer.borderWidth = 2
        applianceListView.layer.borderColor = UIColor(hexString: "#F09553").cgColor
        applianceListView.layer.cornerRadius = 10
        
        if isFromMoodRoutineSettings {
            variableApplianceSwitch.isHidden = true
                variableAppianceView.isHidden = false
                applianceListView.isHidden = true
             variableApplianceName.text = self.applianceSelected.applianceName!
             if self.applianceSelected.applianceName == "Fan"{
                circularSlider.isHidden = false
                stepperView.isHidden = true
                circularSlider.transform = CGAffineTransform(rotationAngle: CGFloat.pi )
                circularSlider.delegate = self
                circularSlider.alpha = 1
                circularSlider.isUserInteractionEnabled = true
                circularSlider.value = (self.applianceSelected.appliancepreviousState)
                previousValue = Int(self.applianceSelected.appliancepreviousState)
                circularSlider.setValue(circularSlider.value, animated: true)
            }
             else{
                circularSlider.isHidden = true
                stepperView.isHidden = false
                previousValue = Int(self.applianceSelected.applianceVariableCount)
                sliderStep.setValue(Float(previousValue), animated: true)
            }
            isFirstLaunch = false
            variableApplianceSwitch.isOn =  true
            
        }
        else{
            variableApplianceSwitch.isHidden = false
        if let image = roomSelected?.imageId {
        roomImage.image = UIImage(named: image)
        }
            
        roomName.text = roomSelected?.roomName!
            if UIDevice.current.screenType == UIDevice.ScreenType.iPhones_5_5s_5c_SE{
                if self.appliancesList.count > 2 {
                    self.heightVaryForView.constant = CGFloat(140 * (( (self.appliancesList.count - 1) / 2) + 1))
                }
                else{
                    self.heightVaryForView.constant = 200
                }
            }
            
            else{
        if self.appliancesList.count > 3 {
            self.heightVaryForView.constant = CGFloat(130 * (( (self.appliancesList.count - 1) / 3) + 1))
        }
        else{
             self.heightVaryForView.constant = 200
        }
        }
        }
        self.view.layoutSubviews()
        
        // Do any additional setup after loading the view.
    }
   
  
    func getAppliances(){
        
        if  let applianceList =  self.roomSelected?.hasAppliance?.allObjects {
            print(applianceList)
            self.appliancesList.removeAll()
           
            self.appliancesList = applianceList as! [Appliances]
         
            
        }
        
        self.roomApplianceCollectionView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stepperChange(_ sender: UISlider) {
        
        let applianceObj = isFromMoodRoutineSettings ? self.applianceSelected : self.appliancesList[self.index!]
       
        if previousValue != Int(sender.value) {
            if let roomId = self.roomSelected?.roomID{
                if isFirstLaunch == true {
                    
                    let newvalue = "0\(Int(sender.value))"
                    if !isFromMoodRoutineSettings {
                        if self.appliancesList[self.index!].applianceStatus == 1 {
                            Socket.soketmanager.send(message: "*\(String(describing: roomId))$$$\(String(describing: self.appliancesList[self.index!].applianceType!))\(newvalue)\(String(describing: self.appliancesList[self.index!].applianceDisplayName!))#")
                        }
                        else{
                            Socket.soketmanager.send(message: "*\(String(describing: roomId))$$$\(String(describing: self.appliancesList[self.index!].applianceType!))00\(String(describing: self.appliancesList[self.index!].applianceDisplayName!))#")
                        }
                        
                        
                        //applianceObj.applianceStatus = 1
                    }
                    previousValue =  Int(sender.value)
//                    applianceObj.applianceVariableCount = Int64(Int(sender.value))
//                    applianceObj.appliancepreviousState = sender.value
//                    coredataUtility.saveContext()
                }
            }
            else if isFromMoodRoutineSettings{
                applianceObj.applianceVariableCount = Int64(Int(sender.value))
                applianceObj.appliancepreviousState = sender.value
                coredataUtility.saveContext()
            }
        }
        
    }

    @IBAction func closeButtonAction(_ sender: UIButton) {
        if isFromMoodRoutineSettings{
            variableAppianceView.isHidden = true
            applianceListView.isHidden = true
            self.delegate?.dissmissView()
        }
        else{
        variableAppianceView.isHidden = true
        applianceListView.isHidden = false
        }
    }
    
    @IBAction func dismissButtonAction(_ sender: UIButton) {
    self.delegate?.dissmissView()
    }
    
    @IBAction func valueChanged(_ sender: UISwitch) {
        isFirstLaunch = true
        if sender.isOn == true {
             if self.appliancesList[self.index!].applianceName == "Fan"{
            circularSlider.alpha = 1
            circularSlider.isUserInteractionEnabled = true
            }
             else{
                sliderStep.alpha = 1
                 sliderStep.isUserInteractionEnabled = true
            }
            if let roomId = self.roomSelected?.roomID{
                
                Socket.soketmanager.send(message: "*\(String(describing: roomId))$$$\(String(describing: self.appliancesList[self.index!].applianceType!))0\(self.appliancesList[self.index!].applianceVariableCount)\(self.appliancesList[self.index!].applianceDisplayName!)#")
//                let applianceObj = self.appliancesList[self.index!]
//                applianceObj.applianceStatus = 1
//                coredataUtility.saveContext()
//                  self.roomApplianceCollectionView.reloadData()
            }
        }
        else{
            if self.appliancesList[self.index!].applianceName == "Fan"{
                circularSlider.alpha = 0.5
                circularSlider.isUserInteractionEnabled = false
            }
            else{
                sliderStep.alpha = 0.5
                sliderStep.isUserInteractionEnabled = false
            }
           
            if let roomId = self.roomSelected?.roomID{
               
                Socket.soketmanager.send(message: "*\(String(describing: roomId))$$$\(String(describing: self.appliancesList[self.index!].applianceType!))00\(self.appliancesList[self.index!].applianceDisplayName!)#")
//                let applianceObj = self.appliancesList[self.index!]
//                applianceObj.applianceStatus = 0
//                coredataUtility.saveContext()
//                self.roomApplianceCollectionView.reloadData()
                
            }
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
extension RoomAppliancesViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.appliancesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : RoomCollectionViewCell = self.roomApplianceCollectionView.dequeueReusableCell(withReuseIdentifier: "roomApplianceCell", for: indexPath) as! RoomCollectionViewCell
        cell.roomApplianceNAme.text = self.appliancesList[indexPath.row].applianceName! + self.appliancesList[indexPath.row].applianceDisplayName!
        
       
        if self.appliancesList[indexPath.row].applianceStatus == 1 {
            if let image = appliancesList[indexPath.row].imageId {
                cell.roomApplianceImage.image = UIImage(named: image)
            }
        }
        else{
           cell.roomApplianceImage.image = UIImage(named: HomeAppliancesConstant().applianceGrey(applianceName: self.appliancesList[indexPath.row].applianceName!))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let status = ( self.appliancesList[indexPath.row].applianceStatus == 0 ) ? "OF" : "ON"
        if let roomId = self.roomSelected?.roomID{
       print("*\(String(describing: roomId))$$$\(String(describing: self.appliancesList[indexPath.row].applianceType!))\(status)\(indexPath.row + 1)#")
        }
        
        self.index = indexPath.row
        
        
        if self.appliancesList[indexPath.row].applianceType == "F" {
       if !Socket.soketmanager.isOpen {
      //  Socket.soketmanager.open(host: "192.168.4.1", port: 1336)
        }
       else{
       
            if let roomId = self.roomSelected?.roomID{
                
                let status = ( self.appliancesList[indexPath.row].applianceStatus == 0 ) ? "ON" : "OF"
                
                Socket.soketmanager.send(message: "*\(String(describing: roomId))$$$\(String(describing: self.appliancesList[indexPath.row].applianceType!))\(status)\(String(describing: self.appliancesList[indexPath.row].applianceDisplayName!))#")
//                let applianceObj = self.appliancesList[indexPath.row]
//                applianceObj.applianceStatus = (status == "ON") ? 1 : 0
//                coredataUtility.saveContext()
            }
        }
        self.roomApplianceCollectionView.reloadData()
        }
        else{
            if !Socket.soketmanager.isOpen {
                
            }
            else{
              //  previousValue = Int(self.appliancesList[indexPath.row].appliancepreviousState)
            variableAppianceView.isHidden = false
            applianceListView.isHidden = true
           
            variableApplianceName.text = self.appliancesList[indexPath.row].applianceName!
            if self.appliancesList[indexPath.row].applianceName == "Fan"{
                circularSlider.isHidden = false
                stepperView.isHidden = true
                circularSlider.transform = CGAffineTransform(rotationAngle: CGFloat.pi )
                circularSlider.delegate = self
                if self.appliancesList[indexPath.row].applianceStatus == 0 {
                    circularSlider.alpha = 0.5
                    circularSlider.isUserInteractionEnabled = false
                    variableApplianceSwitch.isOn =  false
                    circularSlider.value = (self.appliancesList[indexPath.row].appliancepreviousState)
                    isFirstLaunch = false
                    
                    circularSlider.setValue(circularSlider.value, animated: true)
                }
                else{
                    circularSlider.alpha = 1
                    variableApplianceSwitch.isOn =  true
                    circularSlider.isUserInteractionEnabled = true
                    isFirstLaunch = false
                    circularSlider.value = (self.appliancesList[indexPath.row].appliancepreviousState)
                    circularSlider.setValue(circularSlider.value, animated: true)
                }
                previousValue = Int(circularSlider.value)
            }
            else{
                
                 if self.appliancesList[indexPath.row].applianceStatus == 0 {
                    sliderStep.alpha = 0.5
                    sliderStep.isUserInteractionEnabled = false
                     variableApplianceSwitch.isOn =  false
                    circularSlider.isHidden = true
                    stepperView.isHidden = false
                    let applianceObj = isFromMoodRoutineSettings ? self.applianceSelected : self.appliancesList[indexPath.row]
                    previousValue = Int(applianceObj.applianceVariableCount)
                    sliderStep.setValue(Float(previousValue), animated: true)
                }
                 else{
                    sliderStep.alpha = 1
                    variableApplianceSwitch.isOn =  true
                    sliderStep.isUserInteractionEnabled = true
                    circularSlider.isHidden = true
                    stepperView.isHidden = false
                    let applianceObj = isFromMoodRoutineSettings ? self.applianceSelected : self.appliancesList[indexPath.row]
                    previousValue = Int(applianceObj.applianceVariableCount)
                    sliderStep.setValue(Float(previousValue), animated: true)
                }
                
                
                
            }
            
           
             isFirstLaunch = true
        }
        }
    }
    
    func socketDidConnect(stream: Stream) {
        if self.appliancesList[self.index!].applianceStatus == 0 {
            if let roomId = self.roomSelected?.roomID{
                Socket.soketmanager.send(message: "*\(String(describing: roomId))$$$\(String(describing: "F"/*self.appliancesList[indexPath.row].applianceType*/))ON\(self.index! + 1)#")
                  let applianceObj = self.appliancesList[self.index!]
                applianceObj.applianceStatus = 1
                coredataUtility.saveContext()
            }
        }
        else{
            if let roomId = self.roomSelected?.roomID{
                Socket.soketmanager.send(message: "*\(String(describing: roomId))$$$\(String(describing: "F"/*self.appliancesList[indexPath.row].applianceType*/))OF\(self.index! + 1)#")
                let applianceObj = self.appliancesList[self.index!]
                applianceObj.applianceStatus = 0
                coredataUtility.saveContext()
            }
        }
         self.roomApplianceCollectionView.reloadData()
        
    }
    func socketDidReceiveMessage(stream: Stream, message: String) {
        print(message)
        if message.count > 0 {
         
        DispatchQueue.main.async {
            CoreDataUtility().receivedMessage(message: message)
            let applianceId = String(message.suffix(2).dropLast())
            
            let index = message.index(message.startIndex, offsetBy: 22)
            let status = String(message[index])
            
            let indexVariable = message.index(message.startIndex, offsetBy: 20)
            let variable = String(message[indexVariable])
            
            
            if variable == "F"{
                self.roomApplianceCollectionView.reloadData()
            }
            else{
                if applianceId == "7"{
                    self.circularSlider.isHidden = false
                    self.stepperView.isHidden = true
                    self.circularSlider.transform = CGAffineTransform(rotationAngle: CGFloat.pi )
                    self.circularSlider.delegate = self
                    if status == "0" {
                        self.circularSlider.alpha = 0.5
                        self.circularSlider.isUserInteractionEnabled = false
                        self.variableApplianceSwitch.isOn =  false
                        self.circularSlider.value = 100
                        self.isFirstLaunch = false
                       self.circularSlider.setValue(self.circularSlider.value, animated: true)
                    }
                    else{
                        self.circularSlider.alpha = 1
                        self.variableApplianceSwitch.isOn =  true
                        self.circularSlider.isUserInteractionEnabled = true
                        self.isFirstLaunch = false
                        self.circularSlider.value = Float(status)!
                        self.circularSlider.setValue(self.circularSlider.value, animated: true)
                    }
                }
                else{
                    
                    if status == "0" {
                        self.sliderStep.alpha = 0.5
                        self.sliderStep.isUserInteractionEnabled = false
                        self.variableApplianceSwitch.isOn =  false
                        self.circularSlider.isHidden = true
                        self.stepperView.isHidden = false
                        
                        self.previousValue = 1
                        self.sliderStep.setValue(Float(self.previousValue), animated: true)
                    }
                    else{
                        self.sliderStep.alpha = 1
                        self.variableApplianceSwitch.isOn =  true
                        self.sliderStep.isUserInteractionEnabled = true
                        self.circularSlider.isHidden = true
                        self.stepperView.isHidden = false
                        
                        self.previousValue = Int(status)!
                        self.sliderStep.setValue(Float(self.previousValue), animated: true)
                    }
                    
                    
                    
                }
                
            }
            self.roomApplianceCollectionView.reloadData()
        }
        
        }
    }
      
}
// MARK: - CircularSliderDelegate
extension RoomAppliancesViewController: CircularSliderDelegate {
    func circularSlider(_ circularSlider: CircularSlider, valueForValue value: Float) -> Float {
        print(value / 100)
       let applianceObj = isFromMoodRoutineSettings ? self.applianceSelected : self.appliancesList[self.index!]
//        previousValue = Int(applianceObj.applianceVariableCount)
        if previousValue != Int(value / 100) {
        if let roomId = self.roomSelected?.roomID{
            if isFirstLaunch == true {
           
            let newvalue = "0\(Int(value / 100))"
                if !isFromMoodRoutineSettings {
                    if self.appliancesList[self.index!].applianceStatus == 1 {
            Socket.soketmanager.send(message: "*\(String(describing: roomId))$$$\(String(describing: self.appliancesList[self.index!].applianceType!))\(newvalue)\(String(describing: self.appliancesList[self.index!].applianceDisplayName!))#")
                    }
                    else{
                         Socket.soketmanager.send(message: "*\(String(describing: roomId))$$$\(String(describing: self.appliancesList[self.index!].applianceType!))00\(self.appliancesList[self.index!].applianceDisplayName!)#")
                    }
               
                   // applianceObj.applianceStatus = 1
                }
//                applianceObj.applianceVariableCount = Int64(Int(value/100))
//                applianceObj.appliancepreviousState = value
                previousValue = Int(value/100)
           // coredataUtility.saveContext()
            }
        }
        else if isFromMoodRoutineSettings{
            applianceObj.applianceVariableCount = Int64(Int(value/100))
            applianceObj.appliancepreviousState = value
            coredataUtility.saveContext()
        }
        }
        return floorf(value)
    }
    
}
