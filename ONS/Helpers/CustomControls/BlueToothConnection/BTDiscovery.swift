//
//  BTDiscovery.swift
//
//  Created by Kevin Darrah on 5/28/15.
//  Copyright (c) 2015 KDcircuits. All rights reserved.
//

import Foundation
import CoreBluetooth

@objc protocol BTDiscoveryDelegate{
    func BTDidConnect(message:CBPeripheral)
    func BTDidConnectToperiperal(name:CBCharacteristic)
   
}

let btDiscoverySharedInstance = BTDiscovery();//the instance of the class.  

class BTDiscovery: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {//The entire Bluetooth Discovery Class

    
   var centralManager: CBCentralManager?
   var peripheralBLE: CBPeripheral?
    var characteristic : CBCharacteristic?
 var delegate:BTDiscoveryDelegate?
  
    
  override init() {
    super.init()
    
   
    let centralQueue =  DispatchQueue(label: "com.kdcircuits")
    
    centralManager = CBCentralManager(delegate: self, queue: centralQueue)
  }//override init
    
  
  func startScanning() {// start scanning for bluetooth devices
    if let central = centralManager {
        print("Scanning Started")
        central.scanForPeripherals(withServices: nil, options: nil)//  make nil to search for all, or specify a service UUID
        print("Looking for Peripherals with Services")
     
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshScreenRequest"), object: nil)
    }
  }
    
    func stopScanning(){//stop scanning
        print("stopped scanning")
        centralManager!.stopScan()
    }
    
    func disconnect(){//disconnect from peripheral
        if let centralManger = centralManager , let periperal = self.peripheralBLE{
        centralManger.cancelPeripheralConnection(periperal)
        }
    }
  
//  var bleService: BTService? {// once connected, this is called to kick off the BTService functions
//    didSet {
//      if let service = self.bleService {
//        print("Starting to Discover Services")
//        service.startDiscoveringServices()
//       // service.reset()
//      }
//    }
//  }
    
    //This function is called when a new peripheral is discovered
   func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("found something")
        // Validate peripheral informatio
        if ((peripheral.name == nil) || (peripheral.name == "")) {//this actually happens frequently, so important to have, otherwise app will crash
            return
        }
        
        print(peripheral.name)
       // if(peripheral.name! == HomeAppliancesConstant.periperalName){
            print("dIGILog002")
            self.peripheralBLE = peripheral
            self.peripheralBLE?.delegate = self
            self.delegate?.BTDidConnect(message: peripheral)
            //connect_to_peripheral(peripheral: peripheralBLE!)
       // }
    }
    

    func connect_to_peripheral(peripheral: CBPeripheral){
        print("Trying to Connect")
        centralManager!.connect(peripheral, options: nil)//connect!
        
    }
  
    //called when connected
   func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    // Create new service class - now go get characteristics
    print("started to connect")
   // self.bleService = BTService(initWithPeripheral: peripheral)
        print("Connected")
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshScreenRequest"), object: nil)
    self.peripheralBLE?.discoverServices(nil)
    
    // Stop scanning for new devices
     central.stopScan()
  }

  //called when disconnected from peripheral
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected")
       // self.bleService = nil;
        self.peripheralBLE = nil;
        
  //      connectButtonTextString = "Connect"
  //      connectionstatusString = "Disconnected"
      
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshScreenRequest"), object: nil)
    }
 
    //called when bluetooth is powered off - clear out all found devices
  func clearDevices() {
    print("BLE OFF or RESETTING")
   // self.bleService = nil
    self.peripheralBLE = nil
  }
    
 //This is called whenever there is a change with the Bluetooth status
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
    switch (central.state) {
    case .poweredOff:
      self.clearDevices()
      print("Bluetooth OFF")
    case .unauthorized:
      // Indicate to user that the iOS device does not support BLE.
      break
      
    case .unknown:
      // Wait for another event
      break
    case .poweredOn:
        print("Bluetooth ON")
        //self.startScanning()
    case .resetting:
      self.clearDevices()
      break
    case .unsupported:
      break
      
    default:
      break
    
    }
  }
    
    
    //called when a new service is found
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("FOUND SERVICES")
        print(peripheral.services as Any)
        
        // Checks
        if (peripheral != self.peripheralBLE) {
            // Wrong Peripheral
            return
        }
        
        if (error != nil) {
            return
        }
        
        if ((peripheral.services == nil) || (peripheral.services!.count == 0)) {
            // No Services
            return
        }
        
        //loop through the services and pull out all characteristics
        for service in peripheral.services! {
            peripheral.discoverCharacteristics(nil, for: service )
        }
        
    }
    
    
    //called when a new characteristic is found
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        
        print("FOUND CHARACHERISTICS")
        print(service.characteristics as Any)

        if (peripheral != self.peripheralBLE) {
            // Wrong Peripheral
            return
        }
        
        if (error != nil) {
            print("error getting characteristics")
            return
        }
        
        //Scan through all of the found characteristics - we already know the expected UUIDs, so assign them while we're discovering them
        for characteristic in service.characteristics! {
            print(characteristic.uuid)
            print(characteristic.properties.rawValue)
            if characteristic.uuid == CBUUID(string: HomeAppliancesConstant.characteristic) && characteristic.properties.rawValue == 60 {
                self.characteristic = characteristic
                self.peripheralBLE?.setNotifyValue(true, for: characteristic )
                self.delegate?.BTDidConnectToperiperal(name: characteristic)
               // self.sendData(txData: "sarga1", characteristic: characteristic)
            }
            
        }
    }
    
    // this function is used to send data to the BLE module and 'call' a certain function via the characteristic
    func sendData(txData: String, characteristic: CBCharacteristic) {
        print("sending \(txData) to \(characteristic)")
        
        //        var formated_data = NSInteger(txData)
        //        let data = NSData(bytes: &formated_data, length: 1)
        //       print(data)
        let data = txData.data(using: .utf8)
        //send it out - note that this must be .withResponse in order to work
        self.peripheralBLE?.writeValue(data as! Data, for: characteristic, type: CBCharacteristicWriteType.withResponse)
        
    }
    
    func sendBTServiceNotificationWithIsBluetoothConnected(isBluetoothConnected: Bool) {
        let connectionDetails = ["isConnected": isBluetoothConnected]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: BLEServiceChangedStatusNotification), object: self, userInfo: connectionDetails)
    }
    
    
    //this fucntion is called automatically when new data is received by the app
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if (characteristic ==  CBUUID(string: HomeAppliancesConstant.characteristic) ){
            print(characteristic.value)
            var data_in = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue)! as String
            data_in = data_in.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            let stringArray = data_in.components(separatedBy: ",")
            print(stringArray)
        }
        print(characteristic.value)
        
    }
    
    
    
    

}

