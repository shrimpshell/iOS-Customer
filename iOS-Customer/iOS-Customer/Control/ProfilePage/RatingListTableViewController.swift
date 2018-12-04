//
//  RatingListTableViewController.swift
//  iOS-Customer
//
//  Created by Una Lee on 2018/11/9.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

class RatingListTableViewController: UITableViewController {
    
    @IBOutlet var ratingListTableView: UITableView!
    
    let TAG = "RatingListTableViewController"
    var refreshAction = UIRefreshControl()
    var ratingItem = [Rating]()
    var customer: Customer?
    let ratingAuth = DownloadAuth.shared
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        pullToRefresh()
        refreshRatingList()
        
    }
    
    //下拉轉圈圈更新
    func pullToRefresh() {
        refreshAction.addTarget(self, action: #selector(RatingListTableViewController.refreshRatingList), for: .valueChanged)
        ratingListTableView.refreshControl = refreshAction
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
        return ratingItem.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ratingCell", for: indexPath) as! RatingDetailTableViewCell

        let rating = ratingItem[indexPath.row]
        cell.rating = rating
        return cell
    }
    
    @objc
    func refreshRatingList() {
        guard  let idCustomer = customer?.idCustomer else {
            printHelper.println(tag: "RatingListTableViewController", line: #line, "idCustomer 解包錯誤")
            return
        }
        ratingAuth.getAllRatingById(idCustomer: idCustomer) { (result, error) in
            if let error = error {
                printHelper.println(tag: "RatingListTableViewController", line: #line, "Rating download error\(error)")
                return
            }
            guard let result = result else {
                printHelper.println(tag: "RatingListTableViewController", line: #line, "result is nil.")
                return
            }
            printHelper.println(tag: "RatingListTableViewController", line: #line, "Retrive Rating List is OK.")
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                else  {
                    printHelper.println(tag: "RatingListTableViewController", line: #line, "Fail to generate jsonData.")
                    return
            }
            let decoder = JSONDecoder()
            guard let resultObject = try? decoder.decode([Rating].self, from: jsonData) else {
                printHelper.println(tag: "RatingListTableViewController", line: #line, "Fail to decoder jsonData.")
                return
            }
            printHelper.println(tag: "RatingListTableViewController", line: #line, "resultObject: \(resultObject)")
            
            self.ratingItem = resultObject
            
            //更新TableView內容
             self.tableView.reloadData()
            
            //讓轉圈圈消失
             self.refreshAction.endRefreshing()
        }
    }
}
