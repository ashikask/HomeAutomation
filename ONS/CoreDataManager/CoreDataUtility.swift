//
//  CoreDataUtility.swift
//  ONS
//
//  Created by ashika on 18/05/18.
//  Copyright © 2018 ashika kalmady. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class  CoreDataUtility {
    
    var managedObjectContext : NSManagedObjectContext?
    var appliancesList : [Appliances] = [Appliances]()
    var roomSelected : Room?
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        managedObjectContext = context
        
    }
    
    func saveContext(){
        do {
            try managedObjectContext?.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func deleteContext(object: NSManagedObject){
        self.managedObjectContext?.delete(object)
    }
    
    func arrayOf<T: NSManagedObject>(_ entity: T.Type,
                                           predicate: NSPredicate? = nil,
                                           sortDescriptor: [NSSortDescriptor]? = nil) -> NSMutableArray? {
        
        let fetchRequest = NSFetchRequest<T>(entityName: NSStringFromClass(T.self))
        
        if predicate != nil {
            fetchRequest.predicate = predicate!
        }
        
        if sortDescriptor != nil {
            fetchRequest.sortDescriptors = sortDescriptor!
        }
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            
            let searchResult = try managedObjectContext?.fetch(fetchRequest)
            if let result = searchResult{
            if result.count > 0 {
                // returns mutable copy of result array
                return NSMutableArray.init(array: result)
            } else {
                // returns nil in case no object found
                return nil
            }
            }
            else{
                  return nil
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    func receivedMessage(message : String ){
        
        if message.count >= 25 {
            let roomId = String(message.prefix(17).dropFirst())
            let predicate = NSPredicate(format: "roomID == %@",  roomId as CVarArg)
            self.getRoom(predicate: predicate, message: message)
        }
        
    }
    
    func getRoom(predicate: NSPredicate, message : String){
        if  let roomLists =   self.arrayOf(Room.self, predicate: predicate, sortDescriptor: nil)  {
            //  print(roomLists ?? 0)
             let index = message.index(message.startIndex, offsetBy: 18)
            let moodOrRoutine = String(message[index])
            
            if moodOrRoutine == "M"{
                
                
                self.getAppliancesForMood(room: roomLists[0] as! Room, message: message)
            }
            else if moodOrRoutine == "R"{
                
            }
            else if roomLists.count > 0 {
                self.getAppliances(room: roomLists[0] as! Room, message: message)
            }
        }
    }
    
    func getAppliancesForMood(room : Room, message : String){
        
        if  let applianceList =  room.hasAppliance?.allObjects {
            //print(applianceList)
            
            self.appliancesList.removeAll()
            let applianceId = String(message.suffix(2).dropLast())
            
            let index = message.index(message.startIndex, offsetBy: 22)
            let status = String(message[index])
            
            let indexVariable = message.index(message.startIndex, offsetBy: 20)
            let variable = String(message[indexVariable])
            
            let appliances = applianceList as! [Appliances]
            
            self.appliancesList = appliances.filter { (object) -> Bool in
                let displayName = (object as Appliances).applianceDisplayName
                return displayName! == applianceId
            }
            
            if  self.appliancesList.count > 0 {
                
                let applianceObj = self.appliancesList[0]
                if variable == "V"{
                    
                    applianceObj.applianceStatus = (status == "0") ? 0 : 1
                    
                    applianceObj.applianceVariableCount = Int64(Int(status)!)
                    applianceObj.appliancepreviousState = Float(status)!
                    
                }
                else{
                    applianceObj.applianceStatus = (status == "N") ? 1 : 0
                    self.saveContext()
                }
            }
            
        }
        
        
    }
    func getAppliances(room : Room, message : String){
        
        if  let applianceList =  room.hasAppliance?.allObjects {
            //print(applianceList)
            
            self.appliancesList.removeAll()
            let applianceId = String(message.suffix(2).dropLast())
            
            let index = message.index(message.startIndex, offsetBy: 22)
            let status = String(message[index])
            
            let indexVariable = message.index(message.startIndex, offsetBy: 20)
            let variable = String(message[indexVariable])
            
            let appliances = applianceList as! [Appliances]
            
            self.appliancesList = appliances.filter { (object) -> Bool in
                let displayName = (object as Appliances).applianceDisplayName
                return displayName! == applianceId
            }
            
           if  self.appliancesList.count > 0 {
            
                let applianceObj = self.appliancesList[0]
            if variable == "V"{
              
                applianceObj.applianceStatus = (status == "0") ? 0 : 1
           
                applianceObj.applianceVariableCount = Int64(Int(status)!)
                applianceObj.appliancepreviousState = Float(status)!
            
            }
            else{
                applianceObj.applianceStatus = (status == "N") ? 1 : 0
                self.saveContext()
            }
            }
            
        }
        
        
    }
    
}


