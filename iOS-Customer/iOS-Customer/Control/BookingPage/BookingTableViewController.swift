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
    
    let TAG = "BookingTableViewController"
    let now = Date()
    var adultCount = 1.0
    var childCount = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 可以選擇的最晚日期時間
        // 設置可以選擇的最晚日期時間
        checkInDatePicker.minimumDate = now
        checkInDatePicker.maximumDate = now + 60 * 60 * 24 * 180
        checkOuteDatePicker.minimumDate = checkInDatePicker.date + 60 * 60 * 24
        checkOuteDatePicker.maximumDate = now + 60 * 60 * 24 * 180
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        guard let chooseRoomVC = segue.destination as? BookingChooseRoomCollectionViewController else {
            return
        }
        let checkInDate = checkInDatePicker.date.getDateString()
        let checkOutDate = checkOuteDatePicker.date.getDateString()
        
        chooseRoomVC.checkInDate = checkInDate
        printHelper.println(tag: self.TAG, line: #line, "\(chooseRoomVC.checkInDate)")
        chooseRoomVC.checkOutDate = checkOutDate
        printHelper.println(tag: self.TAG, line: #line, "\(chooseRoomVC.checkOutDate)")
        
        adultCount = adultCosmosView.rating
        printHelper.println(tag: self.TAG, line: #line, "\(adultCount)")
        childCount = childCosmosView.rating
        printHelper.println(tag: self.TAG, line: #line, "\(childCount)")
    }
    

}

extension Date {
    func getDateString() -> String {
        // 設置 Date 的格式
        let formatter = DateFormatter()
        
        // 設置時間顯示的格式
        formatter.dateFormat = "yyyy-MM-dd"
        let dateStr = formatter.string(from: self)
        return dateStr
    }
    
    func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return components.day ?? 0
    }
}

extension String {
    func getStringToDate() -> Date {
        // 設置 Date 的格式
        let formatter = DateFormatter()
        
        // 設置時間顯示的格式
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.ReferenceType.system
        let date = formatter.date(from: self)
        return date!
    }
    
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}
