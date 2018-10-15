//
//  MoodsLightViewController.swift
//  ONS
//
//  Created by SHIVA KUMAR on 19/07/18.
//  Copyright © 2018 ashika kalmady. All rights reserved.
//

import UIKit
import CoreBluetooth

class MoodsLightViewController: UIViewController {

    @IBOutlet var colorWheel: UIView!
    @IBOutlet weak var btTableView: UITableView!
    @IBOutlet weak var colorWheelview: RotatingColorWheel!
    @IBOutlet weak var statusSwitch: UISwitch!
    @IBOutlet weak var connectedStatusLabel: UILabel!
    @IBOutlet weak var colorSchemeView: UIView!
    @IBOutlet weak var BLListingView: UIView!
    var isButtonSelected : Bool = false
    var isAutoSelected : Bool = false
    @IBOutlet var waterButton : DLRadioButton!;
  //  var btSearch : BTDiscovery = BTDiscovery()
    var periperal : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //    colorWheelview.delegate = self
       
       // btDiscoverySharedInstance.centralManager.
        
        
        colorWheelview.padding = 14.0
        colorWheelview.centerRadius = 9.0
        colorWheelview.minCircleRadius = 8.0
        colorWheelview.maxCircleRadius = 13.0
        colorWheelview.innerPadding = 6
        colorWheelview.shiftDegree = 0
        colorWheelview.density = 1.0
        btDiscoverySharedInstance.delegate = self
        self.BLListingView.isHidden = false
        self.colorWheel.isHidden = true
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Mood Lighting"
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor(hexString: "#F09553")]
        navigationController?.navigationBar.barTintColor = UIColor.lightGray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func scanForBluetooth(_ sender: UIButton) {
        btDiscoverySharedInstance.startScanning()
    }
    
    
    @IBAction func buttonSelectionAction(_ sender: DLRadioButton) {
        isButtonSelected = true
          print(String(format: "%@ is selected.\n", sender.selected()!.titleLabel!.text!));
       let selectedButton = sender.selected()!.titleLabel!.text!
        if selectedButton == "Auto"{
            isAutoSelected = true
            let stringAppend = "$$$@FFAUTO00#"
            
            btDiscoverySharedInstance.sendData(txData: stringAppend, characteristic: btDiscoverySharedInstance.characteristic!)
        }
            else{
               isAutoSelected = false
            let stringAppend = "$$$$$$$$$@FFMANU00#"
            btDiscoverySharedInstance.sendData(txData: stringAppend, characteristic: btDiscoverySharedInstance.characteristic!)
        }
    }
    
    @IBAction func colorButtonAction(_ sender: UIButton) {
        let color = sender.backgroundColor!
        print(color.toHexString())
        if isAutoSelected == false && isButtonSelected == true {
            
            let stringAppend = "$$$@FF"
            let color = sender.backgroundColor!
            print(color.toHexString())
            let dataToSend = color.toHexString().uppercased()
            btDiscoverySharedInstance.sendData(txData: (stringAppend + dataToSend + "#"), characteristic: btDiscoverySharedInstance.characteristic!)
        }
        
    }
    @IBAction func valueChangeOnSwitch(_ sender: UISwitch) {
        
        if sender.isOn{
            if isButtonSelected == true && isAutoSelected == false {
                let stringAppend = "$$$@FFON0000#"
               
                btDiscoverySharedInstance.sendData(txData: stringAppend, characteristic: btDiscoverySharedInstance.characteristic!)
                
            }
        }
        else{
            
            if isButtonSelected == true && isAutoSelected == false {
                let stringAppend = "$$$@FFOF0000#"
               
                btDiscoverySharedInstance.sendData(txData: stringAppend, characteristic: btDiscoverySharedInstance.characteristic!)
                
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
extension MoodsLightViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return periperal.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "btList", for: indexPath)
        let periperalName : CBPeripheral =  periperal[indexPath.row] as! CBPeripheral
        cell.textLabel?.text = periperalName.name!
        cell.textLabel?.font = UIFont(name: "Gill Sans", size: 22)
        cell.textLabel?.textColor = UIColor(hexString: "#F09553")
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        btDiscoverySharedInstance.peripheralBLE = periperal[indexPath.row] as! CBPeripheral
        
         btDiscoverySharedInstance.connect_to_peripheral(peripheral: btDiscoverySharedInstance.peripheralBLE!)
       
       
        
    }
}

extension MoodsLightViewController : BTDiscoveryDelegate{
    
    func BTDidConnect(message: CBPeripheral) {
        DispatchQueue.main.async {
            self.periperal.add(message)
            self.btTableView.delegate = self
            self.btTableView.dataSource = self
            self.btTableView.reloadData()
        }
        
    }
    
    func BTDidConnectToperiperal(name: CBCharacteristic) {
        DispatchQueue.main.async {
        self.connectedStatusLabel.text = "Connected"
        self.BLListingView.isHidden = true
        self.colorWheel.isHidden = false
        }
    }
    
}
extension MoodsLightViewController: ColorWheelDelegate {
    func didSelect(color: UIColor) {
        if isAutoSelected == false && isButtonSelected == true && statusSwitch.isOn{
       print(color.toHexString())
        let stringAppend = "$$$@FF"
        let dataToSend = color.toHexString().uppercased()
            btDiscoverySharedInstance.sendData(txData: (stringAppend + dataToSend + "#"), characteristic: btDiscoverySharedInstance.characteristic!)
        }
    }
}

