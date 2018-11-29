//
//  ItemDetailTableViewController.swift
//  iOS-Customer
//
//  Created by Josh Hsieh on 2018/11/15.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit
import PromiseKit
import Starscream

class ItemDetailTableViewController: UITableViewController, UITextFieldDelegate, WebSocketDelegate {
   
    let download = DownloadAuth.shared
    var targetIndex: Int = -1
    var payDetailInfo = [OrderRoomDetail]()
    
    let itemImageForDinling = ["icon_dinling_a","icon_dinling_b","icon_dinling_c"]
    let itemLabelForDinling = ["A餐","B餐","C餐"]
    let itemImageForTraffic = ["icon_traffic_plant","icon_traffic_train","icon_traffic_higeway"]
    let itemLabelForTraffic = ["機場接送","車站接送","高鐵接送"]
    let itemImageForRoomService = ["icon_room_service_clean","icon_room_service_washing","icon_room_service_gotoroom","icon_room_service_gotoroom"]
    let itemLabelForRoomService = ["清潔房間","洗衣服務","枕頭備品","盥洗用具"]
    var itemCount: Int = -1
    var serviceName: String = ""
    var serviceType: Int?
    var serviceQuantity: Int?
    var serviceInstantService: Int?
    var idRoomStatus: Int? = nil
    var socket: WebSocket!
    

    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.post(name: .notificationDisConnectName, object: nil)
        
        guard let userId = customerInt?.description else {
            return
        }
        socketConnect(userId: userId, groupId: "0")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if socket.isConnected {
            socket.disconnect()
            NotificationCenter.default.post(name: .notificationConnectName, object: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        switch targetIndex {
        case 0:
            itemCount = itemImageForDinling.count
        case 1:
            itemCount = itemImageForTraffic.count
        default:
            itemCount = itemImageForRoomService.count
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemCount
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemDetailTableViewCell
        // Configure the cell...
        switch targetIndex {
        case 0:
            cell.itemDetailImages.image = UIImage(named: itemImageForDinling[indexPath.row])
            cell.itemDetailLabel.text = itemLabelForDinling[indexPath.row]
            
        case 1:
            cell.itemDetailImages.image = UIImage(named: itemImageForTraffic[indexPath.row])
            cell.itemDetailLabel.text = itemLabelForTraffic[indexPath.row]
            
        default:
            cell.itemDetailImages.image = UIImage(named: itemImageForRoomService[indexPath.row])
            cell.itemDetailLabel.text = itemLabelForRoomService[indexPath.row]
           
        }
        
//        cell.layer.cornerRadius = 20
//        cell.layer.shadowColor = UIColor.gray.cgColor
//        cell.layer.shadowOffset = CGSize(width: 10, height: 10)
//        cell.layer.shadowOpacity = 5
//        cell.layer.masksToBounds = false
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ItemDetailTableViewCell
        
        
        switch targetIndex {
        case 0:
            serviceName = itemLabelForDinling[indexPath.row].description
        case 1:
            serviceName = itemLabelForTraffic[indexPath.row].description
        case 2:
            serviceName = itemLabelForRoomService[indexPath.row].description
        default:
            break
        }
        
        switch serviceName {
        case "A餐":
            serviceType = 1
            serviceInstantService = 3
        case "B餐":
            serviceType = 2
            serviceInstantService = 3
        case "C餐":
            serviceType = 3
            serviceInstantService = 3
        case "機場接送":
            serviceType = 4
            serviceInstantService = 2
        case "車站接送":
            serviceType = 5
            serviceInstantService = 2
        case "高鐵接送":
            serviceType = 6
            serviceInstantService = 2
        case "清潔房間":
            serviceType = 7
            serviceInstantService = 1
        case "洗衣服務":
            serviceType = 8
            serviceInstantService = 2
        case "枕頭備品":
            serviceType = 9
            serviceInstantService = 2
        case "盥洗用具":
            serviceType = 10
            serviceInstantService = 2
        default:
            break
        }
        
        serviceQuantity = Int(cell.itemTextField.text!)
        
        guard let senderId = customerInt?.description, let receiverId = serviceInstantService?.description else {
            return
        }
        
        
        let socketMessage = Socket(senderId: senderId , receiverId: receiverId, senderGroupId: "0", receiverGroupId: receiverId , serviceId: serviceInstantService!, instantNumber: 0)
        let socketData = try! JSONEncoder().encode(socketMessage)
        let socketString = String(data: socketData, encoding: .utf8)!
        
        
        
        let alert = UIAlertController(title: "確定送出需求嗎？", message: "服務需求無誤嗎？", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            
            guard self.serviceQuantity != nil else {
                self.showAlert(title: "沒有輸入正確數量", message: "請再重新輸入")
                return
            }
        
            let instant = Instant(idInstantDetail: 0, idInstantService: self.serviceInstantService!, status: 1, quantity: self.serviceQuantity!, idInstantType: self.serviceType!, idRoomStatus: (self.payDetailInfo.first?.idRoomStatus)!, roomNumber: (self.payDetailInfo.first?.roomNumber)!)
            
            
            
            // 新增物件到 server 端，必先要把物件轉成 String
            let instantData = try! JSONEncoder().encode(instant)
            let instantString = String(data: instantData, encoding: .utf8)
            self.download.insertInstant(instant: instantString!) { (result, error) in
                if let error = error {
                    print("InsertInstant text error: \(error)")
                    return
                }
                print("InsertInstant text OK: \(result!)")
                self.showAlert(title: "已成功送出需求", message: "馬上為您服務")
                self.tableView.reloadData()
                self.socket.write(string: socketString)
            }
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
        self.tableView.reloadData()
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    

    func socketConnect(userId: String, groupId: String) {
        socket = WebSocket(url: URL(string: Common.SOCKET_URL + userId + "/" + groupId)!)
        socket.delegate = self
        socket.connect()
    }

    func websocketDidConnect(socket: WebSocketClient) {
        print("ItemDetail websocket is connected")
    }

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("ItemDetail websocket is disconnected: \(error!.localizedDescription)")
    }

    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("ItemDetail got some text: \(text)")

    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("ItemDetail got some data: \(data.count)")
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        
    }
    */

    
}
