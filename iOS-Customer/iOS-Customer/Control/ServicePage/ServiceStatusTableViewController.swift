//
//  ServiceStatusTableViewController.swift
//  iOS-Customer
//
//  Created by Josh Hsieh on 2018/11/15.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit
import Starscream
import UserNotifications



class ServiceStatusTableViewController: UITableViewController, WebSocketDelegate {

    let download = DownloadAuth.shared
    var arrayInstantStatus: [String] = []
    var arrayInstantService: [String] = []
    var arrayInstantType: [String] = []
    var arrayInstantQuantity: [String] = []
    var instantDetailInfo = [Instant]()
    var payDetailInfo = [OrderRoomDetailForSocket]()
    var socket: WebSocket!
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.allowsSelection = false
        
        guard let userId = customerInt?.description else {
            return
        }
        
        socketConnect(userId: userId, groupId: "0")
        
        getUserRoomNumberForInstant()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if socket.isConnected {
            socketDisConnect()
          
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    
    func setCell() {
        
        arrayInstantStatus.removeAll()
        arrayInstantType.removeAll()
        arrayInstantService.removeAll()
        arrayInstantQuantity.removeAll()
        
        
        for status in instantDetailInfo {
            switch status.status {
            case 1:
                self.arrayInstantStatus.append("icon_unfinish")
            case 2:
                self.arrayInstantStatus.append("icon_playing")
            case 3:
                self.arrayInstantStatus.append("icon_finish")
            default:
                break
            }
        }
        
        for service in instantDetailInfo {
            switch service.idInstantService {
            case 1:
                self.arrayInstantService.append("清潔服務")
            case 2:
                self.arrayInstantService.append("房務服務")
            case 3:
                self.arrayInstantService.append("餐點服務")
            default:
                break
            }
        }
        
        for type in instantDetailInfo {
            switch type.idInstantType {
            case 1:
                self.arrayInstantType.append("A餐")
            case 2:
                self.arrayInstantType.append("B餐")
            case 3:
                self.arrayInstantType.append("C餐")
            case 4:
                self.arrayInstantType.append("機場接送")
            case 5:
                self.arrayInstantType.append("車站接送")
            case 6:
                self.arrayInstantType.append("高鐵接送")
            case 7:
                self.arrayInstantType.append("清潔服務")
            case 8:
                self.arrayInstantType.append("洗衣服務")
            case 9:
                self.arrayInstantType.append("枕頭備品")
            case 10:
                self.arrayInstantType.append("盥洗用具")
            default:
                break
            }
        }
        
        for quantity in instantDetailInfo {
            self.arrayInstantQuantity.append(String(quantity.quantity))
        }
        
        print("Debug >>> setCell")
        tableView.reloadData()
    }
    
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return instantDetailInfo.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ServiceStatusTableViewCell

        // Configure the cell...
        
        cell.statusImage.image = UIImage(named: arrayInstantStatus[indexPath.row])
        cell.statusLabelForInstantService.text = arrayInstantService[indexPath.row]
        cell.statusLabelForServiceType.text = arrayInstantType[indexPath.row]
        cell.statusLabelForCount.text = arrayInstantQuantity[indexPath.row]
    
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    // get user service status
    func updateUserServiceStatus() {
        download.getCustomerStatus(roomNumber: (payDetailInfo.first?.roomNumber)!) { (result, error) in
            if let error = error {
                print("updateUserServiceStatus error: \(error)")
                return
            }
            guard let result = result else {
                print("result is nil.")
                return
            }
            print("updateUserServiceStatus Info is OK.")
            // Decode as [Instant]. 解碼下載下來的 json
            guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {
                print("updateUserServiceStatus Fail to generate jsonData.")
                return
            }
            let decoder = JSONDecoder()
            guard let resultObject = try? decoder.decode([Instant].self, from: jsonData) else {
                print("updateUserServiceStatus Fail to decode jsonData.")
                return
            }
            print("updateUserServiceStatus resultObject: \(resultObject)")
            
            self.instantDetailInfo = resultObject
            print("Debug >>> instantDetailInfo  \(self.instantDetailInfo)")
            
            self.setCell()
        }
    }
    
    func getUserRoomNumberForInstant() {
        guard let customer = customerInt else {
            assertionFailure("error")
            return
        }
        download.getUserRoomNumber(idCustomer: String(customer)) { (result, error) in
            if let error = error {
                print("getUserRoomNumberForInstant error: \(error)")
                return
            }
            guard let result = result else {
                print("getUserRoomNumberForInstant result is nil.")
                return
            }
            print("getUserRoomNumberForInstant Info is OK.")
            // Decode as [PayDetail]. 解碼下載下來的 json
            guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {
                print("getUserRoomNumberForInstant Fail to generate jsonData.")
                return
            }
            let decoder = JSONDecoder()
            guard let resultObject = try? decoder.decode([OrderRoomDetailForSocket].self, from: jsonData) else {
                print("getUserRoomNumberForInstant Fail to decode jsonData.")
                return
            }
            print("getUserRoomNumberForInstant resultObject: \(resultObject)")
            
            for userDetail in resultObject {
                if userDetail.roomReservationStatus == "1" {
                    self.payDetailInfo.append(userDetail)
                }
            }
            guard self.payDetailInfo.count == 1 else {
                self.showAlert(message: "太多房間了！")
                return
            }
            self.updateUserServiceStatus()
        }
    }
    
        
    
    func socketConnect(userId: String, groupId: String) {
        socket = WebSocket(url: URL(string: Common.SOCKET_URL + userId + "/" + groupId)!)
        socket.delegate = self
        socket.connect()
    }

    func socketDisConnect() {
        socket.disconnect()
    }

    func websocketDidConnect(socket: WebSocketClient) {
        print("Status websocket is connected")
    }

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("Status websocket is disconnected: \(error!.localizedDescription)")
    }

    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("Status got some text: \(text)")
        let decoder = JSONDecoder()
        let jsonData = text.data(using: String.Encoding.utf8, allowLossyConversion: true)!
        let message = try! decoder.decode(Socket.self, from: jsonData)

        getUserRoomNumberForInstant()
        //showUserNotifications()
        
    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Status got some data: \(data.count)")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    

}
