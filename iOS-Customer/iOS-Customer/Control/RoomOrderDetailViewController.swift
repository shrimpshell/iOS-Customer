//
//  RoomOrderDetailViewController.swift
//  iOS-Customer
//
//  Created by Hsin Hwang on 2018/11/9.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

class RoomOrderDetailViewController: UIViewController {
    var rooms: [OrderRoomDetail]?
    var instants: [OrderInstantDetail]?
    var amount: Int = 0
    
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
                print("2")
                rateBUtton.isHidden = true
                checkStatusButton.isHidden = true
            case "1":
                print("1")
                rateBUtton.isHidden = true
                checkStatusButton.setTitle("退房", for: .normal)
            default:
                print("0")
                rateBUtton.isHidden = true
            }
        } else {
            checkStatusButton.isHidden = true
        }
        self.amountLabel.text = "總金額：\(amount)"
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
    
    private func showInstantDetails() {
        guard let instants = self.instants, let instantTypeName = instants[0].instantTypeName else {
            return
        }
        for instant in instants {
            self.instantLabel.text = self.instantLabel.text! + "\(instantTypeName) x \(String(describing: instant.quantity))\n"
            amount = amount + Int(instant.instantPrice!)!
        }
    }
}
