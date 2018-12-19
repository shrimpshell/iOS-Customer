//
//  RatingViewController.swift
//  iOS-Customer
//
//  Created by Una Lee on 2018/11/9.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit
import Cosmos

class WritingRatingViewController: UIViewController {
    let TAG = "WritingRatingViewController"
    
    var idRoomReservation: Int = 0
    let ratingAuth = RatingAuth()
    
    
    @IBOutlet weak var ratingStarView: CosmosView!
    @IBOutlet weak var opinionText: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardHight), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // 把TabBar藏起來
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    
    @IBAction func sendRatingBtnPressed(_ sender: UIBarButtonItem) {
        var opinion = ""
        
        //取得當前時間
        let now: Date = Date()
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let dateString: String = dateFormat.string(from: now)
        print("現在時間：\(dateString)")
        
        let ratingStar = Float(ratingStarView.rating)
        if opinionText.text != nil {
             opinion = opinionText.text
        }
        let rating = Rating(ratingStar: ratingStar, time: dateString, opinion: opinion, ratingStatus: 1, idRoomReservation: idRoomReservation)
        let ratingData = try! JSONEncoder().encode(rating)
        let ratingString = String(data: ratingData, encoding: .utf8)
        let insertRating = ["action": "ratingInsert", "rating": ratingString] as! [String:Any]
        print("ratingString: \(ratingString)")
        ratingAuth.insertRating(insertRating).done {
            (result) in
            if result != "0" {
                printHelper.println(tag: "WritingRatingViewController", line: #line, "評論上傳成功 \(result)")
                self.performSegue(withIdentifier: "toPayDetailPage", sender: self.sendRatingBtnPressed)
                
            } else {
                self.showAlert(message: "評論添加失敗")
            }
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "蝦殼飯店", message: "取消撰寫", preferredStyle: .alert)
        let ok = UIAlertAction(title: "確定", style: .destructive){
            (action) in
            self.performSegue(withIdentifier: "toPayDetailPage", sender: self.cancelBtnPressed)
            
        }
        let cancel = UIAlertAction(title: "取消", style: .default)
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
    
    //彈出鍵盤時提高畫面
    @objc
    func keyboardHight(_ notification:Notification){
        let info = notification.userInfo
        let kbRect = (info?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let offsetY = kbRect.origin.y - UIScreen.main.bounds.height
        UIView.animate(withDuration: 0.1) {
            print("\(offsetY)")
            if offsetY == 0 {
                self.view.transform = CGAffineTransform(translationX: 0, y: 0)
            }else{
                self.view.transform = CGAffineTransform(translationX: 0, y: offsetY)
            }
        }
    }
}
