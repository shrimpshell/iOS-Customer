//
//  BookingTableViewController.swift
//  iOS-Customer
//
//  Created by HUNG-HSUN LIN on 2018/11/9.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit
import Cosmos

class BookingTableViewController: UITableViewController {

    @IBOutlet weak var checkInDatePicker: UIDatePicker!
    @IBOutlet weak var checkOuteDatePicker: UIDatePicker!
    @IBOutlet weak var adultCosmosView: CosmosView!
    @IBOutlet weak var childCosmosView: CosmosView!
    
    let now = Date()
    var checkInDate = Date()
    var checkOutDate = Date()
    var adultCount = 1.0
    var childCount = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // 設置 Date 的格式
        let formatter = DateFormatter()
        
        // 設置時間顯示的格式
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 8)
        
        // 可以選擇的最晚日期時間
        // 設置可以選擇的最晚日期時間
        checkInDatePicker.minimumDate = now
        checkInDatePicker.maximumDate = now + 60 * 60 * 24 * 180
        checkOuteDatePicker.minimumDate = now
        checkOuteDatePicker.maximumDate = now + 60 * 60 * 24 * 180
        
        //當用戶通過觸摸視圖更改評級時調用的閉包。
        //這可以用來更新UI，因為通過移動手指來更改評級。
        adultCosmosView.didTouchCosmos = { rating in }
        childCosmosView.didTouchCosmos = { rating in }
        
        //僅顯示完全填充的星星，其他填充模式：.half，.precise
        adultCosmosView.settings.fillMode = .full
        childCosmosView.settings.fillMode = .full
        
        //設置星星之間的距離
        adultCosmosView.settings.starMargin = 3
        childCosmosView.settings.starMargin = 3

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
        
        checkInDate = checkInDatePicker.date
        print(checkInDate)
        checkOutDate = checkOuteDatePicker.date
        print(checkOutDate)
        adultCount = adultCosmosView.rating
        print(adultCount)
        childCount = childCosmosView.rating
        print(childCount)
    }
    

}
