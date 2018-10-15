//
//  BTService.swift
//
//  Created by Kevin Darrah on 5/28/15.
//  Copyright (c) 2015 KDcircuits. All rights reserved.
//

import Foundation
import CoreBluetooth

let BLEServiceChangedStatusNotification = "kBLEServiceChangedStatusNotification"

class BTService: NSObject, CBPeripheralDelegate {
    var peripheral: CBPeripheral?

  
  init(initWithPeripheral peripheral: CBPeripheral) {
    super.init()
    self.peripheral = peripheral
    self.peripheral?.delegate = self
  }
  
  deinit {
    self.reset()
  }
  
    //we'll just discover all services
  func startDiscoveringServices() {
    self.peripheral?.discoverServices(nil)//[BLEServiceUUID]
  }
  
  func reset() {
    print("service reset")
    if peripheral != nil {
      peripheral = nil
    }
    
    // Deallocating therefore send notification
    self.sendBTServiceNotificationWithIsBluetoothConnected(isBluetoothConnected: false)
  }
  
    //called when a new service is found
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    print("FOUND SERVICES")
        print(peripheral.services as Any)
    
    // Checks
    if (peripheral != self.peripheral) {
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
    
    if (peripheral != self.peripheral) {
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
            if characteristic.uuid == CBUUID(string: HomeAppliancesConstant.characteristic) {
                self.peripheral?.setNotifyValue(true, for: characteristic )
                self.sendData(txData: "sarga1", characteristic: characteristic)
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
        self.peripheral?.writeValue(data as! Data, for: characteristic, type: CBCharacteristicWriteType.withResponse)
        
        
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

    
  
