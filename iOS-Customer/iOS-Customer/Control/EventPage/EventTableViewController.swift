//
//  EventTableViewController.swift
//  Event
//
//  Created by Lucy on 2018/11/14.
//  Copyright © 2018 Lucy. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController {
    
    
    @IBOutlet var eventsTableView: UITableView!
    var events = [Event]()
    let communicator = Communicator.shared
    let PHOTO_URL = Common.SERVER_URL + "/EventServlet"
    var eventsImages = [Int: UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "customer_global_background")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        //註冊通知
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: UIApplication.willResignActiveNotification, object: nil)
    
        if events.count == 0 {
            //取得活動訊息資訊（文字部分）
            communicator.getAllEvents{ (result, error) in
                if let error = error {
                    print(" Load Data Error: \(error)")
                    return
                }
                guard let result = result else {
                    print (" result is nil")
                    return
                }
                print("Load Data OK.")
                
                guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {
                    print(" Fail to generate jsonData.")
                    return
                }
                //解碼
                let decoder = JSONDecoder()
                guard let resultObject = try? decoder.decode([Event].self, from: jsonData) else {
                    print(" Fail to decode jsonData.")
                    return
                }
                for eventItem in resultObject {
                    self.events.append(eventItem)
                }
                
                
                DispatchQueue.main.async {
                    self.eventsTableView.reloadData()
                }
            }
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        events.removeAll()
    }
    
    @objc func save() {
       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }

    
    //dataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventTableViewCell
        
        let event = events[indexPath.row]
        let id = event.eventId
        
        communicator.getPhotoById(photoURL: self.PHOTO_URL, id: id) { (result, error) in
            
            guard let data = result else {
                return
            }
            
            if let currentIndexPath = tableView.indexPath(for: cell), currentIndexPath == indexPath {
                DispatchQueue.main.async {
                    cell.eventImageView.image = UIImage(data: data)
                    let eventImage = cell.eventImageView.image!
                    self.eventsImages[event.eventId] = eventImage
                    print("eventsImages: \(self.eventsImages)")
                }
                cell.nameLabel.text = event.name
                cell.startDateLabel.text = event.start
                cell.endDateLabel.text = event.end
            }
        }
        return cell
        
    }
    
    @IBAction func eventDetailBtnPressed(_ sender: UIButton) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            let event = events[selectedIndexPath.row]
            let eventName = event.name
            let dateRange = event.start + "-" + event.end
            let formatMessage = "活動內容：" + event.description + "\n活動期間： \(dateRange)\n" + "全部\(event.discount)折！"
            let alertController = UIAlertController(title: eventName, message: formatMessage, preferredStyle: .alert)
            alertController.addImage(image: self.eventsImages[event.eventId]!)
            alertController.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
}
