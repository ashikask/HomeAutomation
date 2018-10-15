//
//  HomeAppliancesConstat.swift
//  ONS
//
//  Created by ashika on 18/05/18.
//  Copyright © 2018 ashika kalmady. All rights reserved.
//

import Foundation

class HomeAppliancesConstant {
    
    static var periperalName = "dIGILog002"
    static var characteristic = "49535343-1e4d-4bd9-ba61-23c647249616"
    static var localipAddress = "192.168.4.1"
    
    enum Rooms : String {
        
        case Kitchen = "Kitchen"
        case LivingRoom = "Living Room"
        case BedRoom = "Bed Room"
        case MasterBedRoom = "Master Bed room"
        case StudyRoom = "Study Room"
        
    }
    
    enum Appliances : String {
        
        case Bulb = "Bulb"
        case Fan = "Fan"
        case TV = "TV"
        case BedLamp = "Bed Lamp"
        case StudyLam = "Study Lam"
        case DimmableLight = "Dimmable Light"
        case GateBulb = "Gate Bulb"
        
    }
    enum Routine : String {
        
        case GoodMorning = "Good Morning"
        case NapsTime = "Naps Time"
        case YogaRoutine = "Yoga Routine"
        case GoodNight = "Good Night"
        case FoodTime = "Food Time"
        
    }
    
    enum Moods : String {
       
        case ChillOut = "Chill Out"
        case LeavingHome = "Leaving Home"
        case MovieNight = "Movie Night"
        case Party = "Party"
        case Reading = "Reading"
        case Working = "Working"
       
    }
    
    enum MoodImages : String {
        
        case ChillOut = "app-design4_0001_Group-14"
        case LeavingHome = "app-design4_0002_Group-13"
        case MovieNight = "app-design4_0000_Group-15"
        case Party = "app-design4_0003_Group-12"
        case Reading = "app-design4_0000_Group-2"
        case Working = "app-design4_0001_Group-1"
    }
    
    enum RoutineImages : String {
        
        case GoodMorning = "app-design4_0012_sun"
        case NapsTime = "app-design4_0008_Group-4"
        case YogaRoutine = "yoga"
        case GoodNight = "app-design4_0000_Vector-Smart-Object"
        case FoodTime = "app-design4_0000_dinner"
    }
    
    enum RoomsImages : String {
        
        case Kitchen = "kitchen"
        case LivingRoom = "livingroom"
        case BedRoom = "bedroom"
        case MasterBedRoom = "masterbedroom"
        case StudyRoom = "appliance-icons_0007_STUDY-ROOM"
        
    }
    
    enum AppliancesImages : String {
        
        case Bulb = "appliance-icons_0022_LIGHTS"
        case Fan = "appliance-icons_0021_FANS"
        case TV = "appliance-icons_0014_TV"
        case BedLamp = "lampLarge"
        case StudyLam = "appliance-icons_0019_STUDY-LAMP"
        case DimmableLight = "appliance-icons_0017_DIM-LIGHT"
        case GateBulb = "appliance-icons_0013_GATE"
        
    }
    enum AppliancesGreyImages : String {
        
        case Bulb = "lightsgrey"//
        case Fan = "fansgrey"
        case TV = "tvgrey"
        case BedLamp = "bedlampgrey"
        case StudyLam = "studylampgrey"
        case DimmableLight = "bathroomgrey"
        case GateBulb = "gategrey"
        
    }
    
    func moodType(forMood: String) -> String {
        
        switch forMood{
        case "Chill Out":
            return "01"
        case "Leaving Home":
            return "02"
        case "Movie Night":
            return "03"
        case "Party":
           return "04"
        case "Reading":
            return "05"
        case "Working":
            return "06"
        default:
            return ""
        }
    }
    
    func routineType(forRoutine: String) -> String {
        
        switch forRoutine{
        case "Good Morning":
            return "01"
        case "Good Night":
            return "02"
        case "Naps Time":
            return "03"
        case "Food Time":
            return "04"
        case "Yoga Routine":
            return "05"
        default:
            return ""
        }
    }
    
    
    func applianceType(forappliance: String) -> String {
        
        switch forappliance{
        case "Bulb":
            fallthrough
        case "Bed Lamp":
            fallthrough
        case "Gate Bulb":
            fallthrough
        case "Study Lam","TV":
            return "F"
        case "Fan":
            fallthrough
        case "Dimmable Light":
            return "V"
        default:
            return ""
        }
    }
    func applianceGrey(applianceName : String) -> String{
        switch applianceName {
        case "Bulb":
            return HomeAppliancesConstant.AppliancesGreyImages.Bulb.rawValue
        case "Bed Lamp":
            return HomeAppliancesConstant.AppliancesGreyImages.BedLamp.rawValue
        case "Gate Bulb":
            return HomeAppliancesConstant.AppliancesGreyImages.GateBulb.rawValue
        case "Fan":
            return HomeAppliancesConstant.AppliancesGreyImages.Fan.rawValue
        case "Study Lam":
            return HomeAppliancesConstant.AppliancesGreyImages.StudyLam.rawValue
        case "TV":
            return HomeAppliancesConstant.AppliancesGreyImages.TV.rawValue
        case "Dimmable Light":
            return HomeAppliancesConstant.AppliancesGreyImages.DimmableLight.rawValue
        default:
            return ""
        }
    }
    func appliance(applianceName : String) -> String{
        switch applianceName {
        case "Bulb":
            return HomeAppliancesConstant.AppliancesImages.Bulb.rawValue
        case "Bed Lamp":
            return HomeAppliancesConstant.AppliancesImages.BedLamp.rawValue
        case "Gate Bulb":
            return HomeAppliancesConstant.AppliancesImages.GateBulb.rawValue
        case "Fan":
            return HomeAppliancesConstant.AppliancesImages.Fan.rawValue
        case "Study Lam":
            return HomeAppliancesConstant.AppliancesImages.StudyLam.rawValue
        case "TV":
            return HomeAppliancesConstant.AppliancesImages.TV.rawValue
        case "Dimmable Light":
            return HomeAppliancesConstant.AppliancesImages.DimmableLight.rawValue
        default:
            return ""
        }
    }
    
    func room(roomName : String) -> String{
        switch roomName {
        case "Kitchen":
            return HomeAppliancesConstant.RoomsImages.Kitchen.rawValue
        case "Living Room":
            return HomeAppliancesConstant.RoomsImages.LivingRoom.rawValue
        case "Bed Room":
            return HomeAppliancesConstant.RoomsImages.BedRoom.rawValue
        case "Master Bed Room":
            return HomeAppliancesConstant.RoomsImages.MasterBedRoom.rawValue
        case "Study Room":
            return HomeAppliancesConstant.RoomsImages.StudyRoom.rawValue
        default:
            return ""
        }
    }
    
    
    
}
