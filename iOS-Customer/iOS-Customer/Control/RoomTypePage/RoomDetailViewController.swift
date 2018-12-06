//
//  RoomDetailViewController.swift
//  Employee
//
//  Created by Lucy on 2018/11/8.
//  Copyright © 2018 Lucy. All rights reserved.
//

import UIKit

class RoomDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var SaveBarButtonItem: UIBarButtonItem!
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RoomDetailTableViewCell
        // Configure the cell...
        
        switch indexPath.row {
        case 0:
            cell.nameLabel.text = "房間名稱"
            cell.typeLabel.text = room.name
        case 1:
            cell.nameLabel.text = "房間大小"
            cell.typeLabel.text = room.roomSize
        case 2:
            cell.nameLabel.text = "床型"
            cell.typeLabel.text = room.bed
        case 3:
            cell.nameLabel.text = "大人人數"
            cell.typeLabel.text = String(room.adultQuantity)
        case 4:
            cell.nameLabel.text = "小孩人數"
            cell.typeLabel.text = String(room.childQuantity)
        case 5:
            cell.nameLabel.text = "庫存數"
            cell.typeLabel.text = String(room.roomQuantity)
        default:
            cell.nameLabel.text = "價錢"
            cell.typeLabel.text = String(room.price)
        }
        return cell
    }
    

    @IBOutlet weak var roomImageView: UIImageView!
    var room: Room!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        roomImageView.image = UIImage(named: room.roomPic)
//        title = room.name
       
        roomImageView.image = UIImage(named: "picture")
        
        defer {
            let imageUrl = Common.SERVER_URL + "/RoomTypeServlet?action=getImage&imageId=\(room.id)"
            
            let url = URL(string: imageUrl)
            
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.roomImageView.image = UIImage(data: data!)
            }
        }
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





