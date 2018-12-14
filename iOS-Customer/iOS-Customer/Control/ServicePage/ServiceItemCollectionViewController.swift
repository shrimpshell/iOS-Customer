//
//  ServiceItemCollectionViewController.swift
//  iOS-Customer
//
//  Created by Josh Hsieh on 2018/11/15.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit
import Starscream
import UserNotifications

private let reuseIdentifier = "Cell"

var customerInt: Int?


class ServiceItemCollectionViewController: UICollectionViewController, WebSocketDelegate {
    
    
    var customer: Customer?
    let arrayItemImages = ["icon_dinling","icon_traffic","icon_room_service"]
    let arrayItemLabels = ["點餐服務","接送服務","房務服務"]
    let download = DownloadAuth.shared
    var instantDetailInfo = [Instant]()
    var payDetailInfo = [OrderRoomDetailForSocket]()
    var socket: WebSocket!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        
        
        customerInt = customer?.idCustomer

        guard let userId = customerInt?.description else {
            return
        }
        socketConnect(userId: userId, groupId: "0")
        



        getUserRoomNumberForInstant()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if socket.isConnected {
            socket.disconnect()
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showItemDetail" {
            
            
            guard let selectedIndexPath = self.collectionView.indexPathsForSelectedItems?.first else {
                assertionFailure("Fail to get selected item's index path.")
                return
            }
            
            guard let navigationVC = segue.destination as? UINavigationController, let targetVC = navigationVC.topViewController as? ItemDetailTableViewController else {
                assertionFailure("Fail to get DetailTableViewController.")
                return
            }
        
            targetVC.payDetailInfo = payDetailInfo
            targetVC.targetIndex = selectedIndexPath.row
        
        } 
        
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return arrayItemImages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ServiceItemCollectionViewCell
    
        // Configure the cell
        
        cell.itemImage.image = UIImage(named: arrayItemImages[indexPath.row])
        cell.itemLabel.text = arrayItemLabels[indexPath.row]
        
        cell.layer.cornerRadius = 20
        
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 10, height: 10)//CGSizeMake(0, 2.0);
        //cell.layer.shadowRadius = 20
        cell.layer.shadowOpacity = 5
        cell.layer.masksToBounds = false
        // cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
    
        return cell
    }
    
    @IBAction func unwindToServiceItemPage(_ Segue: UIStoryboardSegue) {
        
    }

    // get user service status
    func updateUserServiceStatus() {
        guard payDetailInfo.first?.roomReservationStatus == "1" else {
            let alert = UIAlertController(title: "無法使用此功能", message: "入住後啟用此功能", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                self.performSegue(withIdentifier: "noRoomNumberItem", sender: nil)
                }
            alert.addAction(ok)
            present(alert, animated: true)
            return
        }
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
                    self.payDetailInfo.removeAll()
                    self.payDetailInfo.append(userDetail)
                }
            }
            print("Debug ServiceItems >>> \(self.payDetailInfo.count)")
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

    func websocketDidConnect(socket: WebSocketClient) {
        print("Item websocket is connected")
    }

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("Item websocket is disconnected: \(error!.localizedDescription)")
    }

    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("Item got some text: \(text)")

    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Item got some data: \(data.count)")
    }
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    
    
    

}

