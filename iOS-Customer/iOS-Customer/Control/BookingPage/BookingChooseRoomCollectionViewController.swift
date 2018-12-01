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
    var events = [Events]()
    var shoppingCar = [String: Int]()
//    var shoppingCar = [ShoppingCar]()
    var checkInDate = ""
    var checkOutDate = ""
    var discount: Float = 1.0
    let fullScreenSize = UIScreen.main.bounds.size
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellLayout.itemSize = CGSize(width: fullScreenSize.width, height: fullScreenSize.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getRoomType()
    }
    
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
            
            // Decode as [Events].
            guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {
                printHelper.println(tag: self.TAG, line: #line, "Fail to generate jsonData.")
                return
            }
            let decoder = JSONDecoder()
            guard let resultsObject = try? decoder.decode([Events].self, from: jsonData) else {
                printHelper.println(tag: self.TAG, line: #line, "Fail to generate jsonData.")
                return
            }
            self.events = resultsObject
            if self.events[0].discount != 0 {
                self.discount = self.events[0].discount
                printHelper.println(tag: self.TAG, line: #line, "\(self.discount)")
                self.collectionView.reloadData()
            } else {
                self.discount = 1
                self.collectionView.reloadData()
            }
        })
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
        cell.roomTypeImageView.image = UIImage(named: "pic_roomtype_2seaview")
        cell.roomTypeLabel.text = roomTypes[indexPath.row].name
        cell.roomSizeLabel.text = roomTypes[indexPath.row].roomSize
        cell.bedQuantityLabel.text = roomTypes[indexPath.row].bed
        cell.peopleQuantityLabel.text = "最多可住 \(roomTypes[indexPath.row].adultQuantity) 位大人"
        cell.remainingRoomsLabel.text = "剩 \(roomTypes[indexPath.row].roomQuantity) 間"
        cell.reservationRoomView.settings.totalStars = roomTypes[indexPath.row].roomQuantity
        cell.reservationRoomView.didFinishTouchingCosmos = {
            rating in
            let roomName = self.roomTypes[indexPath.row].name
            let reservationQuantity = Int(cell.reservationRoomView.rating)
            let alert = UIAlertController(title: "房間選擇", message: "確定要選擇\"\(roomName)\" \(reservationQuantity) 間", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "取消", style: .cancel)
            let ok = UIAlertAction(title: "確認", style: .default, handler: { (ok) in
                self.shoppingCar[roomName] = reservationQuantity
//                self.shoppingCar.append(ShoppingCar(roomTypeName: roomName, checkInDate: self.checkInDate, checkOutDate: self.checkOutDate, roomQuantity: reservationQuantity, price: self.roomTypes[indexPath.row].price))
            })
            alert.addAction(cancel)
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
        
        if discount == 1 {
            cell.eventLabel.isHidden = true
            cell.priceLabel.text = "NT$  \(roomTypes[indexPath.row].price)"
        } else {
            cell.eventLabel.isHidden = false
            let price = Float(roomTypes[indexPath.row].price) * discount
            cell.priceLabel.text = "NT$  \(Int(price))"
            cell.eventLabel.text = "打 \(discount) 折"
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
        printHelper.println(tag: self.TAG, line: #line, "checkIn: \(checkIn), checkOut: \(checkOut)")
        checkRoomVC.roomReservation = shoppingCar
        checkRoomVC.checkInDate = checkIn
        checkRoomVC.checkOutDate = checkOut
//        printHelper.println(tag: self.TAG, line: #line, "\(checkRoomVC.checkInDate), \(checkRoomVC.checkOutDate)")
    }
}
