//
//  RoomsViewController.swift
//  ONS
//
//  Created by ashika kalmady on 02/05/18.
//  Copyright © 2018 ashika kalmady. All rights reserved.
//

import UIKit

class RoomsViewController: UIViewController , UIPopoverPresentationControllerDelegate{

    @IBOutlet weak var roomTableview: UITableView!
    var popoverView : AppliancePopOverTableViewController?
    let coredataUtility : CoreDataUtility = CoreDataUtility.init()
    var roomsList : [Room] = [Room]()
    var selectedRoom : Room?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if  let roomLists =  coredataUtility.arrayOf(Room.self){
          //  print(roomLists ?? 0)
            self.roomsList = roomLists as! [Room]
        }
        self.navigationItem.title = "Rooms"
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor(hexString: "#F09553")]
          navigationController?.navigationBar.barTintColor = UIColor.lightGray
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     // MARK: - button action
    @IBAction func addMoreRoomsAction(_ sender: UIButton) {
        self.ShowPopOver(isUpdate: false,forIndex: 0)
    }
   
    func ShowPopOver(isUpdate: Bool,forIndex: Int){
        let modalViewController : AddUpdateRoomViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddUpdateRoomViewController") as! AddUpdateRoomViewController
        if isUpdate == true{
        modalViewController.selectedRoom = self.roomsList[0]
        }
        modalViewController.isForAppliance = false
        modalViewController.isUpdate = isUpdate
        modalViewController.delegate = self
        modalViewController.modalPresentationStyle = .overCurrentContext
        self.present(modalViewController, animated: true, completion: nil)
    }
    
    @IBAction func settingsAction(_ sender: UIButton) {
        self.selectedRoom = self.roomsList[sender.tag]
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        popoverView  = storyboard.instantiateViewController(withIdentifier: "AppliancePopOverTableViewController") as? AppliancePopOverTableViewController
        popoverView?.modalPresentationStyle = UIModalPresentationStyle.popover
        popoverView?.delegate = self
        popoverView?.popOverArray = ["Add Appliances", "Update RoomId"]
        let popover: UIPopoverPresentationController = popoverView!.popoverPresentationController!
        popover.delegate = self
        popover.permittedArrowDirections = .up
        popover.sourceView = sender
        popover.sourceRect = sender.bounds
        
        self.present(popoverView!, animated: true, completion:nil)
    }
    
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
extension RoomsViewController : AppliancePopOverProtocol{
    
    func didSelectItem(index: Int) {
        popoverView?.dismiss(animated: true, completion: nil)
        switch index {
        case 0 :
            let modalViewController : AddUpdateRoomViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddUpdateRoomViewController") as! AddUpdateRoomViewController
            
            modalViewController.isUpdate = false
            modalViewController.isForAppliance = true
            modalViewController.delegate = self
            modalViewController.modalPresentationStyle = .overCurrentContext
            present(modalViewController, animated: true, completion: nil)
        case 1:
            
            self.ShowPopOver(isUpdate: true,forIndex : index)
        default:
            break
        }
    }
}

extension RoomsViewController : AddUpdateRoomProtocol,RoomAppliancesProtocol{
   
    func updateData(oldRoomId: String, newRoomId: String) {
        let predicate = NSPredicate(format: "roomId = %@", oldRoomId)
        let rooms =  coredataUtility.arrayOf(Room.self, predicate: predicate, sortDescriptor: nil) as! [Room]
        if rooms.count > 0{
            let room : Room = rooms[0]
            room.roomID = newRoomId
        }
        coredataUtility.saveContext()
        roomsList =  coredataUtility.arrayOf(Room.self) as! [Room]
        self.roomTableview.reloadData()
    }
    
    func addData(roomName: String, roomId: String, roomImage: String) {
       
        let newRoom : Room = Room(context: coredataUtility.managedObjectContext!)
        
        newRoom.r_id = UtilityClass().randomString(length: 8)
        newRoom.roomID = roomId
        newRoom.roomName = roomName
        newRoom.imageId = roomImage
        coredataUtility.saveContext()
        
         Socket.soketmanager.send(message: "*ROOMADD$$$\(roomId)#")
        
        roomsList =  coredataUtility.arrayOf(Room.self) as! [Room]
        self.roomTableview.reloadData()
        
    }
    func addappliance(forAppliance: String, applianceName: String, applianceImage : String) {
        
        let newAppliance : Appliances = Appliances(context: coredataUtility.managedObjectContext!)
        newAppliance.applianceId = UtilityClass().randomString(length: 8)
        newAppliance.applianceName = forAppliance
        newAppliance.applianceDisplayName = applianceName
        newAppliance.applianceStatus = 0
        newAppliance.applianceVariableCount = 1
        if applianceName == "7" {
        newAppliance.appliancepreviousState = 100.0
        }
        else{
            newAppliance.appliancepreviousState = 1.0
        }
        newAppliance.applianceType = HomeAppliancesConstant().applianceType(forappliance: forAppliance)
        newAppliance.imageId = applianceImage
        selectedRoom?.addToHasAppliance(newAppliance)
        coredataUtility.saveContext()
    }
    
    func dissmissView() {
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension RoomsViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : RoomsTableViewCell = self.roomTableview.dequeueReusableCell(withIdentifier: "roomsCell", for: indexPath) as! RoomsTableViewCell
        // cell.applianceName.text = appliancesList[indexPath.row]
        cell.roomName.text = roomsList[indexPath.row].roomName
        if let image = roomsList[indexPath.row].imageId {
        cell.roomImage.image = UIImage(named: image)
        }
        cell.roomButton.tag = indexPath.row
        cell.roomButton.addTarget(self, action: #selector(settingsAction(_:)), for: UIControlEvents.touchUpInside)
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let modalViewController : RoomAppliancesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RoomAppliancesViewController") as! RoomAppliancesViewController
        modalViewController.delegate = self
        modalViewController.roomSelected = self.roomsList[indexPath.row]
        modalViewController.modalPresentationStyle = .overCurrentContext
        present(modalViewController, animated: true, completion: nil)
    }
}
