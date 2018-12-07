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
    @IBOutlet weak var roomReviewButton: UIButton!
    @IBOutlet weak var eventsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        buttonSetup()
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
    
    func buttonSetup() {
        ratingButton.clipsToBounds = true
        roomReviewButton.clipsToBounds = true
        eventsButton.clipsToBounds = true
        
        ratingButton.layer.cornerRadius = 10
        roomReviewButton.layer.cornerRadius = 10
        eventsButton.layer.cornerRadius = 10
        
        ratingButton.titleLabel?.shadowColor = .black
        roomReviewButton.titleLabel?.shadowColor = .black
        eventsButton.titleLabel?.shadowColor = .black
    }
}

