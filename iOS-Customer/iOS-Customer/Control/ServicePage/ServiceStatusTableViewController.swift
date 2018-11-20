//
//  ServiceStatusTableViewController.swift
//  iOS-Customer
//
//  Created by Josh Hsieh on 2018/11/15.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

var instantDetailInfo = [Instant]()

class ServiceStatusTableViewController: UITableViewController {

    let download = DownloadAuth.shared
    
    var arrayInstantStatus: [String] = []
    var arrayInstantService: [String] = []
    var arrayInstantType: [String] = []
    var arrayInstantQuantity: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.allowsSelection = false
        
        for status in instantDetailInfo {
            switch status.status {
            case 1:
                self.arrayInstantStatus.append("icon_unfinish")
            case 2:
                self.arrayInstantStatus.append("icon_playing")
            default:
                self.arrayInstantStatus.append("icon_finish")
            }
        }
       
        for service in instantDetailInfo {
            switch service.idInstantService {
            case 1:
                self.arrayInstantService.append("清潔服務")
            case 2:
                self.arrayInstantService.append("房務服務")
            default:
                self.arrayInstantService.append("餐點服務")
            }
        }
        
        for type in instantDetailInfo {
            switch type.idInstantType {
            case 1:
                self.arrayInstantType.append("A餐")
            case 2:
                self.arrayInstantType.append("B餐")
            case 3:
                self.arrayInstantType.append("C餐")
            case 4:
                self.arrayInstantType.append("機場接送")
            case 5:
                self.arrayInstantType.append("車站接送")
            case 6:
                self.arrayInstantType.append("高鐵接送")
            case 7:
                self.arrayInstantType.append("清潔服務")
            case 8:
                self.arrayInstantType.append("洗衣服務")
            case 9:
                self.arrayInstantType.append("枕頭備品")
            default:
                self.arrayInstantType.append("盥洗用具")
            }
        }
        
        for quantity in instantDetailInfo {
            self.arrayInstantQuantity.append(String(quantity.quantity))
        }
       
        
        
    }

    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return instantDetailInfo.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ServiceStatusTableViewCell

        // Configure the cell...
        
        cell.statusImage.image = UIImage(named: arrayInstantStatus[indexPath.row])
        cell.statusLabelForInstantService.text = arrayInstantService[indexPath.row]
        cell.statusLabelForServiceType.text = arrayInstantType[indexPath.row]
        cell.statusLabelForCount.text = arrayInstantQuantity[indexPath.row]
        
    
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
