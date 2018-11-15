//
//  AllRatingDetailViewController.swift
//  iOS-Customer
//
//  Created by Una Lee on 2018/11/15.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit
import Cosmos

class AllRatingDetailViewController: UIViewController {
    static let TAG = "AllRatingDetailViewController"
    
    var rating: Rating?

    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var idRoomReservationLabel: UILabel!
    @IBOutlet weak var ratingStarView: CosmosView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var opinionLabel: UITextView!
    @IBOutlet weak var customerServiceLabel: UILabel!
    @IBOutlet weak var customerServiceResponseLabel: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
showDetail()
        
    }
    
    func showDetail() {
        guard  let idRoomReservation = rating?.idRoomReservation else {
            printHelper.println(tag: "ProfileViewController", line: #line, "Rating idRoomReservation is nil")
            print("Rating idRoomReservation is nil")
            return
        }
        if rating?.idRoomReservation != nil {
            idRoomReservationLabel.text = "\(idRoomReservation)"
        } else {
            idRoomReservationLabel.text = ""
        }
        
        if rating?.name != nil {
            customerNameLabel.text = rating?.name
        }
        
        if rating?.ratingStar != nil {
            ratingStarView.rating = Double((rating?.ratingStar)!)
            ratingStarView.settings.updateOnTouch = false
        } else {
            ratingStarView.rating = 1
            ratingStarView.settings.updateOnTouch = false
        }
        
        if rating?.opinion != nil {
            opinionLabel.text = rating?.opinion
        } else {
            opinionLabel.isHidden = true
        }
        
        if rating?.time != nil {
            dateLabel.text = rating?.time
        } else {
            dateLabel.isHidden = true
        }
        
        if rating?.review != nil {
            customerServiceResponseLabel.text = rating?.review
        } else {
            customerServiceLabel.isHidden = true
            customerServiceResponseLabel.isHidden = true
        }
    }
    


}
