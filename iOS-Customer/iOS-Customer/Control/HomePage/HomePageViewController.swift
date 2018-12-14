//
//  ViewController.swift
//  iOS-Customer
//
//  Created by Hsin Hwang on 2018/10/4.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet weak var roomButton: UIButton!
    @IBOutlet weak var eventButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        changeButton()
    }
    
    // 顯示TabBar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAllCustomerRatingsPage" {
            let NAVController = segue.destination as? UINavigationController
            let ratingListPage = NAVController?.viewControllers.first as! AllRatingsTableViewController
            ratingListPage.pageNumber = 1
        }
    }

     @IBAction func unwindToHomePage(_ segue: UIStoryboardSegue){

    }
    
    func changeButton() {
        self.ratingButton.layer.cornerRadius = 10
        self.roomButton.layer.cornerRadius = 10
        self.eventButton.layer.cornerRadius = 10
        
        self.ratingButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 36)
        self.roomButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 36)
        self.eventButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 36)
    }
}

