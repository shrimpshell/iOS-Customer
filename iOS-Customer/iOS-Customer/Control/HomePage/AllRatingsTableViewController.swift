//
//  AllRatingsTableViewController.swift
//  iOS-Customer
//
//  Created by Una Lee on 2018/11/14.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

class AllRatingsTableViewController: UITableViewController {
    
    static let TAG = "AllRatingsTableViewController"
    var refreshAction = UIRefreshControl()
    var allRatingItems = [Rating]()
    let ratingAuth = DownloadAuth.shared
    
    
    @IBOutlet var allCustomerRatiingsTableView: UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        showAllCustomerRatings(key: "getAll")
        refreshRatings()
      
    }
    
    //下拉轉圈圈更新
    func refreshRatings() {
        refreshAction.addTarget(self, action: #selector(AllRatingsTableViewController.pullToRefresh), for: .valueChanged)
        refreshAction.attributedTitle = NSAttributedString(string: "刷新評論")
        allCustomerRatiingsTableView.refreshControl = refreshAction
    }
    
    // 把TabBar藏起來
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
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
 
    @IBAction func changeSearchBtnPressered(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: "排序方式", preferredStyle: .actionSheet)
        
        let firstBtn = UIAlertAction(title: "最新評價", style: .default) {
            (action) in
            self.showAllCustomerRatings(key: "getAll")
        }
        
        let secondBtn = UIAlertAction(title: "最高評價", style: .default){
            (action) in
            self.showAllCustomerRatings(key: "getAllByHighRatingStar")
        }
        
        let thirdBtn = UIAlertAction(title: "最低評價", style: .default) { (action) in
            self.showAllCustomerRatings(key: "getAllByLowRatingStar")
        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel)
        
        alert.addAction(firstBtn)
        alert.addAction(secondBtn)
         alert.addAction(thirdBtn)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func showAllCustomerRatings(key: String) {
        ratingAuth.getAllCustomerRatings(key: key) { (result, error) in
            if let error = error {
                printHelper.println(tag: AllRatingsTableViewController.TAG, line: #line, "Rating download error\(error)")
                return
            }
            guard let result = result else {
                printHelper.println(tag: AllRatingsTableViewController.TAG, line: #line, "result is nil.")
                return
            }
            print("Retrive all ratings list is OK.")
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                else  {
                    printHelper.println(tag: AllRatingsTableViewController.TAG, line: #line, "Fail to generate jsonData.")
                    return
            }
            let decoder = JSONDecoder()
            guard let resultObject = try? decoder.decode([Rating].self, from: jsonData) else {
                printHelper.println(tag: AllRatingsTableViewController.TAG, line: #line, "Fail to decoder jsonData.")
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
    
    @objc
    func pullToRefresh() {
        showAllCustomerRatings(key:"getAll")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRatingDetails" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let rating = allRatingItems[indexPath.row]
                let controller = segue.destination as!  AllRatingDetailViewController
                controller.rating = rating
                
            }
        }
        
//            if let selectedIndexPath = tableView.indexPathForSelectedRow {
//                if(segue.identifier == "showRatingDetails"){
//                let rating = allRatingItems[selectedIndexPath.row]
//                let controller = segue.destination as! AllRatingDetailViewController
//                controller.rating = rating
//
//            }
//        }
    }
    
}
