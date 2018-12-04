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
        showRoomDetails()
        showInstantDetails()
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
        guard let instants = self.instants, let instantTypeName = instants[0].instantTypeName else {
            return
        }
        for instant in instants {
            self.instantLabel.text = self.instantLabel.text! + "\(instantTypeName) x \(String(describing: instant.quantity))\n"
            amount = amount + Int(instant.instantPrice!)!
        }
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
        let orderRoomDB = OrderRoomDB()
        let roomGroup = rooms[0].roomGroup
        let roomReservationStatus = buttonTitle == "入住" ? "1" : "2"
        let parameters =  ["action":"updateRoomReservationStatusById", "roomGroup":roomGroup, "roomReservationStatus": roomReservationStatus] as [String : String]
        
        orderRoomDB.updateRoomReservationStatusById(parameters).done { (result) in
            guard result != "0" else {
                printHelper.println(tag: "RoomOrderDetailViewController", line: #line, "fail to update")
                return
            }
            
            self.updateRooms(status: roomReservationStatus)
            
            if buttonTitle == "退房" {
                self.checkStatusButton.isHidden = true
                return
            }
            self.checkStatusButton.setTitle("退房", for: .normal)
        }
    }
    
  
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        if segue.identifier == "toWritingRatingPage" {
//            let writingRating = segue.destination as! WritingRatingViewController
//            writingRating.roomDetail = rooms[0].
//
//        }
//
//    }
//
    
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