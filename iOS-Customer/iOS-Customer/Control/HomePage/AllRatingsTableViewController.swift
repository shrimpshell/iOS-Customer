//
//  AllRatingsTableViewController.swift
//  iOS-Customer
//
//  Created by Una Lee on 2018/11/14.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

class AllRatingsTableViewController: UITableViewController {
    
    let TAG = "AllRatingsTableViewController"
    var refreshAction = UIRefreshControl()
    var allRatingItems = [Rating]()
    let ratingAuth = DownloadAuth.shared
    
    
    @IBOutlet var allCustomerRatiingsTableView: UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        showAllCustomerRatings()
        pullToRefresh()
      
    }
    
    //下拉轉圈圈更新
    func pullToRefresh() {
        refreshAction.addTarget(self, action: #selector(AllRatingsTableViewController.showAllCustomerRatings), for: .valueChanged)
        allCustomerRatiingsTableView.refreshControl = refreshAction
    }
    
    // 把TabBar藏起來
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc
    func showAllCustomerRatings() {
        ratingAuth.getAllCustomerRatings { (result, error) in
            if let error = error {
                printHelper.println(tag: self.TAG, line: #line, "Rating download error\(error)")
                return
            }
            guard let result = result else {
                printHelper.println(tag: self.TAG, line: #line, "result is nil.")
                return
            }
            print("Retrive all ratings list is OK.")
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                else  {
                    printHelper.println(tag: self.TAG, line: #line, "Fail to generate jsonData.")
                    return
            }
            let decoder = JSONDecoder()
            guard let resultObject = try? decoder.decode([Rating].self, from: jsonData) else {
                printHelper.println(tag: self.TAG, line: #line, "Fail to decoder jsonData.")
                return
            }
            print("resultObject: \(resultObject)")
            self.allRatingItems = resultObject
            
            //更新TableView內容
            self.tableView.reloadData()
            
            //讓轉圈圈消失
            self.refreshAction.endRefreshing()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allRatingItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allRatingCell", for: indexPath) as! AllRatingsTableViewCell

        let allRating = allRatingItems[indexPath.row]
        cell.allRating = allRating

        return cell
    }
 

   
}
