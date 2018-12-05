//
//  RoomTableViewController.swift
//  Employee
//
//  Created by Lucy on 2018/11/8.
//  Copyright © 2018 Lucy. All rights reserved.
//

import UIKit

class RoomTableViewController: UITableViewController {
    
    var objects = [Room]()
    let communicator = Communicator.shared
    
    //增加背景圖
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Add a background view to the table view
        let backgroundImage = UIImage(named: "customer_global_background")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("RoomTableViewController")
        
        let urlString = Common.SERVER_URL + "/RoomTypeServlet?action=getAll"
        
        guard let url = URL(string: urlString) else {
            assertionFailure("Invalid URL string.")
            return
        }
        
        RoomDownloaderAndUploader.downloadRoom(url: url) { (rooms, error) in
            if let error = error {
                print("Download Room: \(error)")
                return
            }
            guard let items = rooms else {
                assertionFailure("rooms is nil.")
                return
            }
            
            print("Items: \(items)")
            for item in items {
                self.objects.append(item)
            }
            
            self.tableView.reloadData()//刷新tableView
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return objects.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RoomTableViewCell
        
        /*cell.nameLabel?.text = objects[indexPath.row].name
        cell.typeLabel?.text = objects[indexPath.row].roomSize
        cell.priceLabel?.text = String(objects[indexPath.row].price)
        cell.roomImage.image = UIImage(named: "picture")
        
        defer {
            let imageUrl = Common.SERVER_URL + "/RoomTypeServlet?action=getImage&imageId=\(objects[indexPath.row].id)"
            
            let url = URL(string: imageUrl)
            
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                cell.roomImage.image = UIImage(data: data!)
            }
        }*/
        
        let room = objects[indexPath.row]
        let id = room.id
        cell.roomImage.image = UIImage(named: "picture")
        communicator.getPhotoById(id: id) { (result, error) in
            
            guard let data = result else {
                return
            }
            
            if let currentIndexPath = tableView.indexPath(for: cell), currentIndexPath == indexPath {
                DispatchQueue.main.async {
                    cell.roomImage.image = UIImage(data: data)
                }
                
                cell.nameLabel?.text = room.name
                cell.typeLabel?.text = room.roomSize
                cell.priceLabel?.text = String(room.price)
                
            }
        }
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view. Swipe-to-delete-向左滑刪除
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            objects.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    
    
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRoomDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! RoomDetailViewController
                destinationController.room = objects[indexPath.row]
            }
        }
    }
    
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
    }
    
}
