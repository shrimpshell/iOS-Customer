//
//  BookingCheckTableViewController.swift
//  iOS-Customer
//
//  Created by HUNG-HSUN LIN on 2018/11/30.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

class BookingCheckTableViewController: UITableViewController {

    var roomReservation = [ShoppingCar]()
    var totalDays = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // row的高度
        tableView.rowHeight = UITableView.automaticDimension
        
        // 開啟 Cell 自動列高
        tableView.estimatedRowHeight = 200
    }
    
    @IBAction func sendReservation(_ sender: UIBarButtonItem) {
        if ProfileViewController.isLogin == true {
            // ...
        } else {
            performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
        }
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
//        cell.minusBtn.addTarget(self, action: #selector(minusRoomQuantity), for: .touchUpInside)
        cell.roomTypeNameLabel.text = roomReservation[indexPath.row].roomTypeName
        cell.checkInDateLabel.text = "入住日期： \(roomReservation[indexPath.row].checkOutDate)"
        cell.checkOutDateLabel.text = "退房日期： \(roomReservation[indexPath.row].checkOutDate)"
        cell.totalDaysLabel.text = "共 \(totalDays) 晚"
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
}
