//
//  RoomOrderDetailViewController.swift
//  iOS-Customer
//
//  Created by Hsin Hwang on 2018/11/9.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

class RoomOrderDetailViewController: UIViewController {
    let customerTask = DownloadAuth.shared
    var roomGroup: String!
    var rooms: [OrderRoomDetail]?
    var instants: [OrderInstantDetail]?
    var amount: Int = 0
    static var ratingStatus = 0
    
    @IBOutlet weak var roomGroupLabel: UILabel!
    @IBOutlet weak var checkinLabel: UILabel!
    @IBOutlet weak var roomsLabel: UILabel!
    @IBOutlet weak var instantLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var rateBUtton: UIButton!
    @IBOutlet weak var checkStatusButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        roomsLabel.text = ""
        instantLabel.text = ""
        discountLabel.text = ""
        showRoomDetails()
        showInstantDetails()
        roomGroup = rooms![0].roomGroup
        if let rooms = rooms, rooms[0].roomReservationStatus != "3" {
            switch rooms[0].roomReservationStatus {
            case "2":
                rateBUtton.isHidden = true
                checkStatusButton.isHidden = true
            case "1":
                rateBUtton.isHidden = true
                checkStatusButton.setTitle("退房", for: .normal)
            default:
                rateBUtton.isHidden = true
            }
        } else {
            checkStatusButton.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rateBUtton.isHidden = true
         if let rooms = rooms, rooms[0].roomReservationStatus == "3" {
            if  rooms[0].idRoomReservation != nil {
                let idRoomReservation = rooms[0].idRoomReservation
                getRatingStatusByIdRoomReservation(idRoomReservation: idRoomReservation)
            }
        }
        
        
        self.amountLabel.text = "總金額：\(amount)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let rooms = self.rooms else {
            return
        }
        switch segue.identifier {
        case "toTableView":
            let roomOrderTableViewController = segue.destination as! RoomOrderTableViewController
            let ord: OrderRoomDictionary = OrderRoomDictionary(id: roomGroup, orderRoomDetails: rooms, orderInstantDetails: instants!)
            for (index, _) in roomOrderTableViewController.detailDictionary.enumerated() {
                if ord.id == roomOrderTableViewController.detailDictionary[index].id {
                    roomOrderTableViewController.detailDictionary[index] = ord
                }
            }
            clearAllDetails()
            
        case "toWritingRatingPage":
            let writingRating = segue.destination as! WritingRatingViewController
                    writingRating.idRoomReservation = rooms[0].idRoomReservation
            
        default:
            break
        }
    }

    private func showRoomDetails() {
        guard let rooms = self.rooms else {
            return
        }
        self.roomGroupLabel.text = "訂單編號：\(rooms[0].roomGroup)"
        self.checkinLabel.text = "入住日期：\(rooms[0].checkInDate)"
        for room in rooms {
            self.roomsLabel.text = self.roomsLabel.text! + "\(room.roomTypeName) x \(room.roomQuantity)\n"
            amount = amount + Int(room.price)!
        }
    }
    
    private func clearAllDetails() {
        self.roomGroupLabel.text = ""
        self.checkinLabel.text = ""
        self.roomsLabel.text = ""
        self.instantLabel.text = ""
        self.discountLabel.text = ""
        self.amountLabel.text = ""
    }
    
    private func showInstantDetails() {
        var aMeal: Int = 0
        var bMeal: Int = 0
        var cMeal: Int = 0
        guard let instants = self.instants, let instantTypeName = instants[0].instantTypeName else {
            return
        }
        for instant in instants {
//            self.instantLabel.text = self.instantLabel.text! + "\(instantTypeName) x \(String(describing: instant.quantity!))\n"
            switch instant.instantTypeName!  {
            case "A餐":
                aMeal = aMeal + Int(instant.quantity!)!
            case "B餐":
                bMeal = bMeal + Int(instant.quantity!)!
            case "C餐":
                cMeal = cMeal + Int(instant.quantity!)!
            default:
                print("unidentified service")
            }
            amount = amount + Int(instant.instantPrice!)!
        }
        
        self.instantLabel.text = "A餐：\(aMeal) \nB餐：\(bMeal) \nC餐：\(cMeal)"
    }
    
    private func updateRooms(status: String) {
        guard let rooms = self.rooms else {
            return
        }
        for (index, _) in rooms.enumerated() {
            self.rooms![index].roomReservationStatus = status
        }
    }
    
    @IBAction func checkStatusBUttonPressed(_ sender: UIButton) {
        guard let buttonTitle = sender.title(for: .normal), let rooms = self.rooms else {
            return
        }
        sender.isEnabled = false
        let orderRoomDB = OrderRoomDB()
        let roomGroup = rooms[0].roomGroup
        let roomReservationStatus = buttonTitle == "入住" ? "1" : "2"
        let parameters =  ["action":"updateRoomReservationStatusById", "roomGroup":roomGroup, "roomReservationStatus": roomReservationStatus] as [String : String]
        let message = buttonTitle == "入住" ? "確定要入住？" : "確定要退房？"
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "確定", style: .default, handler: {
            _ in
            orderRoomDB.updateRoomReservationStatusById(parameters).done { (result) in
                guard result != "0" else {
                    printHelper.println(tag: "RoomOrderDetailViewController", line: #line, "fail to update")
                    return
                }
                
                self.updateRooms(status: roomReservationStatus)
                sender.isEnabled = true
                
                if buttonTitle == "退房" {
                    self.checkStatusButton.isHidden = true
                    return
                }
                self.checkStatusButton.setTitle("退房", for: .normal)
            }
        })
        let cancel = UIAlertAction(title: "取消", style: .destructive, handler: {
            _ in
            sender.isEnabled = true
        })
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func getRatingStatusByIdRoomReservation(idRoomReservation: Int) {
        customerTask.getRatingStatus(idRoomReservation: idRoomReservation) { (result, error) in
            if let error = error {
                printHelper.println(tag: "RoomOrderDetailViewController", line: #line, "RatingStatus download error: \(error)")
                return
            }
            guard let result = result else {
                printHelper.println(tag: "RoomOrderDetailViewController", line: #line, "RatingStatus result is nil.")
                return
            }
            RoomOrderDetailViewController.ratingStatus = result as! Int
            print("ratingStatus: \(RoomOrderDetailViewController.ratingStatus)")
            printHelper.println(tag: "RoomOrderDetailViewController", line: #line, "RatingStatus is OK.")
            if RoomOrderDetailViewController.ratingStatus == 0 {
                self.rateBUtton.isHidden = false
            } else {
                self.rateBUtton.isHidden = true
            }
        }
    }
    
    func changeStatusAlert(title: String? = nil, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "確定", style: .default)
        let cancel = UIAlertAction(title: "取消", style: .destructive)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    @IBAction func unwindToDetailPage(_ segue: UIStoryboardSegue) {
        switch segue.identifier {
        case "submitDetail":
             printHelper.println(tag: "RoomOrderDetailViewController", line: #line, "submit")
            break
        case "cancelDetail":
             printHelper.println(tag: "RoomOrderDetailViewController", line: #line, "cancel")
            break
        default:
            printHelper.println(tag: "RoomOrderDetailViewController", line: #line, "did notthing")
        }
    }
}
