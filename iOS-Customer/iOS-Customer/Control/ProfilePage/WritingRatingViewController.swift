//
//  RatingViewController.swift
//  iOS-Customer
//
//  Created by Una Lee on 2018/11/9.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

class WritingRatingViewController: UIViewController {
    let TAG = "WritingRatingViewController"
    
    var customer: Customer?
    let ratingAuth = DownloadAuth.shared
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // 把TabBar藏起來
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    @IBAction func sendRatingBtnPressed(_ sender: UIBarButtonItem) {
        
        //取得當前時間
        let now: Date = Date()
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let dateString: String = dateFormat.string(from: now)
        print("“現在時間：\(dateString)”")
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "蝦殼飯店", message: "取消撰寫", preferredStyle: .alert)
        let ok = UIAlertAction(title: "確定", style: .destructive){
            (action) in
            self.performSegue(withIdentifier: "toReceiptList", sender: action)
        }
        let cancel = UIAlertAction(title: "取消", style: .default)
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
    
   
//    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
//        let alert = UIAlertController(title: "蝦殼飯店", message: "取消撰寫", preferredStyle: .alert)
//        let ok = UIAlertAction(title: "確定", style: .destructive){
//            (action) in
//            self.performSegue(withIdentifier: "toReceiptList", sender: action)
//        }
//        let cancel = UIAlertAction(title: "取消", style: .default)
//        alert.addAction(cancel)
//        alert.addAction(ok)
//
//        present(alert, animated: true, completion: nil)
//    }

    
}
