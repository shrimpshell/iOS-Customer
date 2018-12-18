//
//  AllRatingsTableViewController.swift
//  iOS-Customer
//
//  Created by Una Lee on 2018/11/14.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

class AllRatingsTableViewController: UITableViewController {
    
    
    var refreshAction = UIRefreshControl()
    var ratingItems = [Rating]()
    let ratingAuth = DownloadAuth.shared
    var customer: Customer?
    var pageNumber = 0
    
    
    @IBOutlet var allCustomerRatiingsTableView: UITableView!
    @IBOutlet weak var rightBtnItem: UIBarButtonItem!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        switch pageNumber {
        case 1:
            showAllCustomerRatings(key: "getAll")
            refreshRatings()
            rightBtnItem.image = UIImage(named: "down")
            rightBtnItem.isEnabled = true
        case 2:
            personalRatingList()
            rightBtnItem.isEnabled = false
            rightBtnItem.title = ""
        default:
            break
        }
        
    }
      
    //下拉轉圈圈更新
    func refreshRatings() {
        refreshAction.addTarget(self, action: #selector(AllRatingsTableViewController.pullToRefresh), for: .valueChanged)
        refreshAction.attributedTitle = NSAttributedString(string: "刷新評論")
        allCustomerRatiingsTableView.refreshControl = refreshAction
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ratingItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allRatingCell", for: indexPath) as! AllRatingsTableViewCell

        let rating = ratingItems[indexPath.row]
        cell.allRating = rating

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
                printHelper.println(tag: "AllRatingsTableViewController", line: #line, "Rating download error\(error)")
                return
            }
            guard let result = result else {
                printHelper.println(tag: "AllRatingsTableViewController", line: #line, "result is nil.")
                return
            }
            print("Retrive all ratings list is OK.")
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                else  {
                    printHelper.println(tag: "AllRatingsTableViewController", line: #line, "Fail to generate jsonData.")
                    return
            }
            let decoder = JSONDecoder()
            guard let resultObject = try? decoder.decode([Rating].self, from: jsonData) else {
                printHelper.println(tag: "AllRatingsTableViewController", line: #line, "Fail to decoder jsonData.")
                return
            }
            printHelper.println(tag: "AllRatingDetailViewController", line: #line, "resultObject: \(resultObject)")
            self.ratingItems = resultObject
            
            //更新TableView內容
            self.tableView.reloadData()
            
            //讓轉圈圈消失
            self.refreshAction.endRefreshing()
        }
    }

@objc
func personalRatingList() {
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
        
        self.ratingItems = resultObject
        
        //更新TableView內容
        self.tableView.reloadData()
        
        //讓轉圈圈消失
        self.refreshAction.endRefreshing()
    }
}
    
    @objc
    func pullToRefresh() {
        switch pageNumber {
        case  1:
            showAllCustomerRatings(key:"getAll")
        case  2:
            personalRatingList()
        default:
            break
        }
    }
    
    
    @IBAction func goBackBtnPressed(_ sender: UIBarButtonItem) {
        switch pageNumber {
        case 1:
            self.performSegue(withIdentifier: "goBackHomePage", sender: nil)
        case 2:
            self.performSegue(withIdentifier: "goBackProfilePage", sender: nil)
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRatingDetails" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let rating = ratingItems[indexPath.row]
                let controller = segue.destination as!  AllRatingDetailViewController
                controller.pageNumber = pageNumber
                controller.rating = rating
                
                
            }
        }
    }
}
