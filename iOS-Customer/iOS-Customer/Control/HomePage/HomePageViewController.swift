//
//  ViewController.swift
//  iOS-Customer
//
//  Created by Hsin Hwang on 2018/10/4.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }
    
    // 顯示TabBar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }

     @IBAction func unwindToHomePage(_ segue: UIStoryboardSegue){

    }
}

