//
//  BookingCheckTableViewController.swift
//  iOS-Customer
//
//  Created by HUNG-HSUN LIN on 2018/11/30.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

class BookingCheckTableViewController: UITableViewController {

    let TAG = "BookingCheckTableViewController"
    var roomReservation = [ShoppingCar]()
    var reservationRoom = [RoomType]()
    var checkInDate = ""
    var checkOutDate = ""
    var reservation = Reservation()
    var customerId = 0
    var totalDays = 1
    var extraBed = 0
    let roomGruopId = UUID().uuidString
    let reservagtionDate = Date().getDateString()
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reservationRoom.removeAll()
        printHelper.println(tag: self.TAG, line: #line, roomGruopId)
        // row的高度
        tableView.rowHeight = UITableView.automaticDimension
        
        // 開啟 Cell 自動列高
        tableView.estimatedRowHeight = 200
    }
    
    // MAKR: - Send reservation.
    
    @IBAction func sendReservation(_ sender: UIBarButtonItem) {
        // Check user is login. The customerId = 0 is not login.
        if customerId == 0 {
            performSegue(withIdentifier: "goToCheckIn", sender: nil)
        } else {
            for index in 0...(roomReservation.count - 1) {
                getReservation(checkInDate: checkInDate, checkOutDate: checkOutDate, roomTypeId: roomReservation[index].id)
                
                // Check that the room the user wants to book can be booked.
                if reservationRoom.isEmpty {
                    let alert = UIAlertController(title: "訂房確認", message: "確定要訂房嗎？", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "確定", style: .default) { (ok) in
                        self.insertReservation(quantity: self.roomReservation[index].roomQuantity, roomTypeId: self.roomReservation[index].id, eventId: self.roomReservation[index].eventid, price: self.roomReservation[index].price)
                    }
                    let cancel = UIAlertAction(title: "取消", style: .destructive)
                    alert.addAction(cancel)
                    alert.addAction(ok)
                    self.present(alert, animated: true)
                } else {
                    //Check if the remaining room is enough for the user to book.
                    for roomIndex in 0...(reservationRoom.count - 1) where roomReservation[index].id == reservationRoom[roomIndex].id {
                        if roomReservation[index].roomQuantity <= reservationRoom[roomIndex].roomQuantity {
                            self.insertReservation(quantity: self.roomReservation[index].roomQuantity, roomTypeId: self.roomReservation[index].id, eventId: self.roomReservation[index].eventid, price: self.roomReservation[index].price)
                        } else {
                            let alert = UIAlertController(title: "訂房失敗", message: "房間已被訂滿，請重新選取。", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "確認", style: .default, handler: { (ok) in
                                self.performSegue(withIdentifier: "backToChooseBooking", sender: nil)
                            })
                            alert.addAction(ok)
                            self.present(alert, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func unwindToBookingCheck(_ segue: UIStoryboardSegue) {
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if roomReservation.count == 0 {
            performSegue(withIdentifier: "checkBooking", sender: nil)
        }
        return roomReservation.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BookingCheckTableViewCell

        // Configure the cell...
        cell.delegate = self
        cell.roomTypeNameLabel.text = roomReservation[indexPath.row].roomTypeName
        cell.checkInDateLabel.text = "入住日期： \(checkOutDate)"
        cell.checkOutDateLabel.text = "退房日期： \(checkOutDate)"
        cell.totalDaysLabel.text = "共 \(totalDays) 晚"
        cell.extraBedLabel.text = "是否要加床:"
        cell.roomQuantityLabel.text = "\(roomReservation[indexPath.row].roomQuantity) 間"
        cell.priceLabel.text = "NT$ \(roomReservation[indexPath.row].price * roomReservation[indexPath.row].roomQuantity)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            roomReservation.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // Change to isFromCheckBooking = true, which means coming from the CheckBooking page.
        let profileVC = segue.destination as! ProfileViewController
        profileVC.isFromCheckBooking = true
    }
    

}

// MARK: - TableViewCellDelegate
// Change room quantity.
extension BookingCheckTableViewController: BookingCheckTableViewCellDelegate {
    
    // Minus room quantity.
    func minusRoomQuantity(_ sender: BookingCheckTableViewCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        guard let roomQuantity = sender.roomQuantityLabel.text?.replace(target: " 間", withString: "") else {
            return
        }
        var quantity = Int(roomQuantity)!
        print(quantity)
        if quantity > 1 {
            quantity -= 1
            sender.roomQuantityLabel.text = "\(quantity) 間"
        }
        let price = roomReservation[tappedIndexPath.row].price
        sender.priceLabel.text = "NT$ \(price * quantity)"
    }
    
    // Plus room quantity.
    func plusRoomQuantity(_ sender: BookingCheckTableViewCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        guard let roomQuantity = sender.roomQuantityLabel.text?.replace(target: " 間", withString: "") else {
            return
        }
        var quantity = Int(roomQuantity)!
        print(quantity)
        let labelQuantity = roomReservation[tappedIndexPath.row].roomQuantity
        if quantity < labelQuantity {
            quantity += 1
            sender.roomQuantityLabel.text = "\(quantity) 間"
        }
        let price = roomReservation[tappedIndexPath.row].price
        sender.priceLabel.text = "NT$ \(price * quantity)"
    }
    
    func extraBedSwitchPressed(_ sender: BookingCheckTableViewCell) {
        guard let price = Int((sender.priceLabel.text?.replace(target: "NT$ ", withString: ""))!) else {
            return
        }
        guard let quaintity = Int((sender.roomQuantityLabel.text?.replace(target: " 間", withString: ""))!) else { return }
        
        if sender.extraBedSwitch.isOn {
            extraBed = 1
            sender.priceLabel.text = "NT$ \(price + 1000 * quaintity)"
        } else {
            extraBed = 0
            sender.priceLabel.text = "NT$ \(price - 1000 * quaintity)"
        }
    }
}

// MARK: - Get data from server.

extension BookingCheckTableViewController {
    func getReservation(checkInDate: String, checkOutDate: String, roomTypeId: Int) {
        RoomTypeCommunicator.shared.getRoomTypeQuantity(checkInDate: checkInDate, checkOutDate: checkOutDate, roomTypeId: roomTypeId, completion: { (result, error) in
            if let error = error {
                printHelper.println(tag: self.TAG, line: #line, "RetriveRoomType error \(error)")
                return
            }
            guard let result = result else {
                printHelper.println(tag: self.TAG, line: #line, "result is nil.")
                return
            }
            printHelper.println(tag: self.TAG, line: #line, "RetriveRoomType OK.")
            
            // Decode as [RoomType].
            guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {
                printHelper.println(tag: self.TAG, line: #line, "Fail to generate jsonData.")
                return
            }
            let decoder = JSONDecoder()
            guard let resultsObject = try? decoder.decode([RoomType].self, from: jsonData) else {
                printHelper.println(tag: self.TAG, line: #line, "Fail to generate jsonData.")
                return
            }
            printHelper.println(tag: self.TAG, line: #line, "resultObject: \(resultsObject)")
            self.reservationRoom = resultsObject
        })
    }
    
    func insertReservation(quantity: Int, roomTypeId: Int, eventId: Int, price: Int) {
        customerId = userDefaults.value(forKey: "userID") as! Int
        let reservation = Reservation(reservationDate: reservagtionDate, checkInDate: checkInDate, checkOutDate: checkOutDate, extraBed: extraBed, quantity: quantity, customerId: customerId, roomTypeId: roomTypeId, eventId: eventId, roomGroup: roomGruopId, price: price)
        let reservationData = try! JSONEncoder().encode(reservation)
        let reservationString = String(data: reservationData, encoding: .utf8)
        RoomTypeCommunicator.shared.insertReservation(reservation: reservationString!) { (result, error) in
            if let error = error {
                printHelper.println(tag: self.TAG, line: #line, "InsertInstant text error: \(error)")
                return
            }
            printHelper.println(tag: self.TAG, line: #line, "InsertInstant text OK: \(result!)")
            self.showAlert(title: "訂房成功", message: "期待您的光臨！")
        }
    }
}
