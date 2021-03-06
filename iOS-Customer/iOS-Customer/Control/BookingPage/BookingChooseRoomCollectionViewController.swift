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
    
    @IBOutlet var bookingChooseRoomCollectionView: UICollectionView!
    @IBOutlet weak var bookingChooseRoomCollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    
    let TAG = "BookingChooseRoomCollectionViewController"
    let communicator = RoomTypeCommunicator.shared
    var days = 0
    var roomTypes = [RoomType]()
    var reservationRoom = [RoomType]()
    var event = Events()
    var shoppingCar = [ShoppingCar]()
    var pic = [UIImage?]()
    var checkInDate = ""
    var checkOutDate = ""
    var discount: Float = 1.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationHeight = UIApplication.shared.statusBarFrame.height +
            self.navigationController!.navigationBar.frame.height
        let cellHeight =  UIScreen.main.bounds.height - navigationHeight
        let cellWidth = bookingChooseRoomCollectionView.frame.width
        
        bookingChooseRoomCollectionViewFlowLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        days = checkInDate.getStringToDate().daysBetweenDate(toDate: checkOutDate.getStringToDate())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        shoppingCar.removeAll()
        collectionView.reloadData()
        getRoomType(checkInDate: checkInDate, checkOutDate: checkOutDate)
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
        
        let room = roomTypes[indexPath.row]
        let name = room.name
        let size = room.roomSize
        let bed = room.bed
        let quantity = room.roomQuantity
        let adult = room.adultQuantity
        let price = room.price
        
        // Configure the cell
        // Download room picture.
        
        cell.roomTypeImageView.image = pic[indexPath.row]
        cell.roomTypeLabel.text = name
        cell.roomSizeLabel.text = size
        cell.bedQuantityLabel.text = bed
        cell.peopleQuantityLabel.text = "最多可住 \(adult) 位大人"
        cell.remainingRoomsLabel.text = "剩 \(quantity) 間"
        cell.reservationQuantity.text = "訂房數量"
        cell.roomQuantityLabel.text = String(roomTypes[indexPath.row].reservationQuantity!)
        cell.reservationStepper.value = 0
        cell.delegate = self
        
        if discount == 1 {
            cell.eventLabel.isHidden = true
            cell.priceLabel.text = "NT$  \(price)"
        } else {
            cell.eventLabel.isHidden = false
            let discontPrice = Float(price) * discount
            cell.priceLabel.text = "NT$  \(Int(discontPrice))"
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
        
        printHelper.println(tag: self.TAG, line: #line, "checkIn: \(checkIn), checkOut: \(checkOut)")
        print(shoppingCar)
        checkRoomVC.roomReservation = shoppingCar
        checkRoomVC.totalDays = days
        checkRoomVC.checkInDate = checkIn
        checkRoomVC.checkOutDate = checkOut
    }
}

// MARK: - Get data from server.

extension BookingChooseRoomCollectionViewController {
    func getRoomType(checkInDate: String, checkOutDate: String) {
        RoomTypeCommunicator.shared.doPostRoomType(checkInDate: checkInDate, checkOutDate: checkOutDate, completion: { (result, error) in
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
            for roomType in self.roomTypes {
                self.getPic(id: roomType.id)
            }
            self.getEvent(checkInDate: checkInDate)
        })
    }
    
    func getEvent(checkInDate: String) {
        RoomTypeCommunicator.shared.doPostEvent(checkInDate: checkInDate, completion: { (result, error) in
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
    
    // Calculate booking rooms.
    func getReservationQuantity(id: Int, name: String, reservationQuantity: Int, eventId: Int = 0, price: Int) {
        let totalPrice = price * reservationQuantity * days
        print(totalPrice)
        if shoppingCar.isEmpty {
            self.shoppingCar.append(ShoppingCar(id: id ,roomTypeName: name, checkInDate: self.checkInDate, checkOutDate: self.checkOutDate, roomQuantity: reservationQuantity, eventId: eventId, price: totalPrice))
        } else if shoppingCar.contains(where: { (shoppingCar) -> Bool in
            shoppingCar.id == id
        }) {
            for index in 0...(shoppingCar.count - 1) where id == self.shoppingCar[index].id {
                if reservationQuantity == 0 {
                    self.shoppingCar.remove(at: index)
                } else {
                   self.shoppingCar[index].roomQuantity = reservationQuantity
                    self.shoppingCar[index].price = price * reservationQuantity * days
                }
            }
        } else {
            self.shoppingCar.append(ShoppingCar(id: id ,roomTypeName: name, checkInDate: self.checkInDate, checkOutDate: self.checkOutDate, roomQuantity: reservationQuantity, eventId: eventId, price: totalPrice))
        }
    }
    
    func getPic(id: Int) {
        let imageUrl = Common.SERVER_URL + "/RoomTypeServlet?action=getImage&imageId=\(id)"
        
        let url = URL(string: imageUrl)
        
        let data = try? Data(contentsOf: url!)
        pic.append(UIImage(data: data!))
    }
}

// MARK: - Choose booking room.
extension BookingChooseRoomCollectionViewController: BookingChooseCollectionViewCellDelegate {
    func chooseRoomStepper(_ sender: BookingChooseCollectionViewCell) {
        guard let tappedIndexPath = collectionView.indexPath(for: sender) else { return }
        let stepper = sender.reservationStepper
        let textValue = Int(sender.reservationStepper.value)
        let room = roomTypes[tappedIndexPath.row]
        let id = room.id
        let name = room.name
        let price = room.price
        
        stepper?.minimumValue = 0
        stepper?.maximumValue = Double(roomTypes[tappedIndexPath.row].roomQuantity)
        sender.roomQuantityLabel.text = String(textValue)
        roomTypes[tappedIndexPath.row].reservationQuantity = textValue
        
        if self.discount == 1 {
            self.getReservationQuantity(id: id, name: name, reservationQuantity: textValue, price: price)
        } else {
            let discountPrice = Float(price) * self.discount
            self.getReservationQuantity(id: id, name: name, reservationQuantity: textValue, eventId: self.event.eventId, price: Int(discountPrice))
            printHelper.println(tag: self.TAG, line: #line, "\(shoppingCar)")
        }
    }
}
