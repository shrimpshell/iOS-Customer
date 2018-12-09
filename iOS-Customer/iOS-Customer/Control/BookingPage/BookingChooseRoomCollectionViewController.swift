//
//  BookingChooseRoomCollectionViewController.swift
//  iOS-Customer
//
//  Created by HUNG-HSUN LIN on 2018/11/14.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

private let reuseIdentifier = "BookingChooseCollectionViewCell"

class BookingChooseRoomCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var cellLayout: UICollectionViewFlowLayout!
    
    let TAG = "BookingChooseRoomCollectionViewController"
    let communicator = RoomTypeCommunicator.shared
    var roomTypes = [RoomType]()
    var reservationRoom = [RoomType]()
    var event = Events()
    var shoppingCar = [ShoppingCar]()
    var checkInDate = ""
    var checkOutDate = ""
    var discount: Float = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInset = collectionView.adjustedContentInset
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        shoppingCar = [ShoppingCar]()
        collectionView.reloadData()
        getRoomType()
    }
    
    @IBAction func checkBookingBtnPressed(_ sender: Any) {
        if !shoppingCar.isEmpty || shoppingCar.count != 0 {
            performSegue(withIdentifier: "checkBooking", sender: nil)
        } else {
            showAlert(message: "尚未選取房間。")
        }
    }
    
    @IBAction func unwindToChooseRoom(_ segue: UIStoryboardSegue) {
        
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        printHelper.println(tag: self.TAG, line: #line, "\(roomTypes.count)")
        return roomTypes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> BookingChooseCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BookingChooseCollectionViewCell
        
            // Configure the cell
            cell.reservationRoomView.rating = 0
            cell.roomTypeImageView.image = UIImage(named: "pic_roomtype_2seaview")
            cell.roomTypeLabel.text = self.roomTypes[indexPath.row].name            
            cell.roomSizeLabel.text = roomTypes[indexPath.row].roomSize
            cell.bedQuantityLabel.text = roomTypes[indexPath.row].bed
            cell.peopleQuantityLabel.text = "最多可住 \(self.roomTypes[indexPath.row].adultQuantity) 位大人"
            cell.remainingRoomsLabel.text = "剩 \(roomTypes[indexPath.row].roomQuantity) 間"
            cell.reservationRoomView.settings.totalStars = roomTypes[indexPath.row].roomQuantity
            cell.reservationRoomView.didFinishTouchingCosmos = {
                rating in
                let reservationQuantity = Int(cell.reservationRoomView.rating)
                let alert = UIAlertController(title: "房間選擇", message: "確定要選擇\"\(self.roomTypes[indexPath.row].name)\" \(reservationQuantity) 間", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "取消", style: .destructive, handler: { (cancel) in
                    cell.reservationRoomView.rating = 0
                })
                let ok = UIAlertAction(title: "確認", style: .default, handler: { (ok) in
                    if self.discount == 1 {
                        self.shoppingCar.append(ShoppingCar(id: self.roomTypes[indexPath.row].id ,roomTypeName: self.roomTypes[indexPath.row].name, checkInDate: self.checkInDate, checkOutDate: self.checkOutDate, roomQuantity: reservationQuantity, price: self.roomTypes[indexPath.row].price))
                    } else {
                        cell.eventLabel.isHidden = false
                        let price = Float(self.roomTypes[indexPath.row].price) * self.discount
                        self.shoppingCar.append(ShoppingCar(id: self.roomTypes[indexPath.row].id, roomTypeName: self.roomTypes[indexPath.row].name, checkInDate: self.checkInDate, checkOutDate: self.checkOutDate, roomQuantity: reservationQuantity, eventid: self.event.eventId, price: Int(price)))
                    }
                })
                alert.addAction(cancel)
                alert.addAction(ok)
                self.present(alert, animated: true)
            }
            
            if discount == 1 {
                cell.eventLabel.isHidden = true
                cell.priceLabel.text = "NT$  \(self.roomTypes[indexPath.row].price)"
            } else {
                cell.eventLabel.isHidden = false
                let price = Float(roomTypes[indexPath.row].price) * discount
                cell.priceLabel.text = "NT$  \(Int(price))"
                cell.eventLabel.text = "打 \(Int(discount * 10)) 折"
            }
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        guard let checkRoomVC = segue.destination as? BookingCheckTableViewController else {
            return
        }
        let checkIn = checkInDate
        let checkOut = checkOutDate
        let days = checkIn.getStringToDate().daysBetweenDate(toDate: checkOut.getStringToDate())
        printHelper.println(tag: self.TAG, line: #line, "checkIn: \(checkIn), checkOut: \(checkOut)")
        checkRoomVC.roomReservation = shoppingCar
        checkRoomVC.totalDays = days
        checkRoomVC.checkInDate = checkIn
        checkRoomVC.checkOutDate = checkOut
    }
}

// MARK: - Get data from server.

extension BookingChooseRoomCollectionViewController {
    func getRoomType() {
        RoomTypeCommunicator.shared.getAllRoomType { (result, error) in
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
            self.roomTypes = resultsObject
            self.getReservation(checkInDate: self.checkInDate, checkOutDate: self.checkOutDate)
        }
    }
    
    func getReservation(checkInDate: String, checkOutDate: String) {
        RoomTypeCommunicator.shared.getRoomType(checkInDate: checkInDate, checkOutDate: checkOutDate, completion: { (result, error) in
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
            self.getRemainingRoom()
        })
    }
    
    func getRemainingRoom() {
        if !reservationRoom.isEmpty {
            let reservationCount = reservationRoom.count - 1
            let roomTypeCount = roomTypes.count - 1
            
            for index in 0...roomTypeCount {
                for roomIndex in 0...reservationCount where roomTypes[index].id == reservationRoom[roomIndex].id {
                    roomTypes[index].roomQuantity = roomTypes[index].roomQuantity - reservationRoom[roomIndex].roomQuantity
                }
            }
        }
        printHelper.println(tag: self.TAG, line: #line, "roomTypes: \(roomTypes.count), reservationRoom: \(reservationRoom.count)")
        self.getEvent(checkInDate: checkInDate)
    }
    
    func getEvent(checkInDate: String) {
        RoomTypeCommunicator.shared.getEvent(checkInDate: checkInDate, completion: { (result, error) in
            if let error = error {
                printHelper.println(tag: self.TAG, line: #line, "RetriveRoomType error \(error)")
                return
            }
            guard let result = result else {
                printHelper.println(tag: self.TAG, line: #line, "result is nil.")
                return
            }
            printHelper.println(tag: self.TAG, line: #line, "RetriveRoomType OK.")
            
            // Decode as Event.
            guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {
                printHelper.println(tag: self.TAG, line: #line, "Fail to generate jsonData.")
                return
            }
            let decoder = JSONDecoder()
            guard let resultsObject = try? decoder.decode(Events.self, from: jsonData) else {
                printHelper.println(tag: self.TAG, line: #line, "Fail to generate jsonData.")
                return
            }
            self.event = resultsObject
            if self.event.discount != 0 {
                self.discount = self.event.discount
                printHelper.println(tag: self.TAG, line: #line, "\(self.discount)")
                self.collectionView.reloadData()
            } else {
                self.discount = 1
                self.collectionView.reloadData()
            }
        })
    }
}
