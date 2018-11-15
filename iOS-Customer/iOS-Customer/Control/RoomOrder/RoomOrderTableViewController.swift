//
//  RoomOrderTableViewController.swift
//  iOS-Customer
//
//  Created by Hsin Hwang on 2018/11/8.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

class RoomOrderTableViewController: UITableViewController {
    
    var orders = [OrderRoomDetail]()
    var instants = [OrderInstantDetail]()
    var targetRooms = [OrderRoomDetail]()
    var targetInstants = [OrderInstantDetail]()
    var detailDictionary = [OrderRoomDictionary]()
    var roomGroup: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.refactorData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return detailDictionary.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        let status = detailDictionary[indexPath.row].orderRoomDetails[0].roomReservationStatus
        var statusString: String
        
        switch status {
        case "3":
            statusString = "已付款"
        case "2":
            statusString = "待付款"
        case "1":
            statusString = "未付款"
        default:
            statusString = "已訂房"
        }
        cell.textLabel!.text = "\(orders[indexPath.row].roomGroup) - \(statusString)"
        cell.detailTextLabel!.text = "預定入住日期：\(orders[indexPath.row].checkInDate)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.targetRooms = detailDictionary[indexPath.row].orderRoomDetails
        self.targetInstants = detailDictionary[indexPath.row].orderInstantDetails
        self.performSegue(withIdentifier: "toDetailPage", sender: nil)
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toDetailPage" {
            let detail = segue.destination as! RoomOrderDetailViewController
            detail.rooms = self.targetRooms
            detail.instants = self.targetInstants
        }
        
    }

    private func refactorData() {
        // 重構結構
        for order in orders {
            if !detailDictionary.contains(where: { (detail) -> Bool in
                return detail.id == order.roomGroup
            }) {
                detailDictionary.append(OrderRoomDictionary(id: order.roomGroup, orderRoomDetails: [], orderInstantDetails: []))
            }
        }
        
        for (index, _) in detailDictionary.enumerated() {
            for order in orders {
                if order.roomGroup == detailDictionary[index].id {
                    detailDictionary[index].orderRoomDetails.append(order)
                }
            }
            for instant in instants {
                if instant.roomGroup == detailDictionary[index].id {
                    detailDictionary[index].orderInstantDetails.append(instant)
                }
            }
        }
    }
    
    @IBAction func unwindToRoomOrderTableView(_ segue: UIStoryboardSegue){
        print("enter unwind")
        guard let roomOrderDetailView = segue.source as? RoomOrderDetailViewController, let rooms = roomOrderDetailView.rooms else {
            print("error")
            return
        }
        print(self.detailDictionary)
        for (index, _) in self.detailDictionary.enumerated() {
            if self.detailDictionary[index].id == rooms[0].roomGroup {
                self.detailDictionary[index].orderRoomDetails = rooms
                break
            }
        }
        self.refactorData()
        self.tableView.reloadData()
    }
}
