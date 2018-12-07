//
//  AllRatingsTableViewCell.swift
//  iOS-Customer
//
//  Created by Una Lee on 2018/11/14.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit
import Cosmos

class AllRatingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var idRoomReservationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingStarCosmosView: CosmosView!
    @IBOutlet weak var opinionLabel: UILabel!
    @IBOutlet weak var customrServiceResponse: UILabel!
    
    var allRating: Rating? {
        didSet {
            guard  let idRoomReservation = allRating?.idRoomReservation else {
                printHelper.println(tag: "ProfileViewController", line: #line, "Rating idRoomReservation is nil")
                return
            }
            if allRating?.idRoomReservation != nil {
                idRoomReservationLabel.text = "\(idRoomReservation)"
            } else {
                idRoomReservationLabel.text = ""
            }
            
            if allRating?.name != nil {
                customerNameLabel.isHidden = false
                customerNameLabel.text = allRating?.name
            } else {
                customerNameLabel.isHidden = true
            }
            
            if allRating?.ratingStar != nil {
                ratingStarCosmosView.rating = Double((allRating?.ratingStar)!)
                ratingStarCosmosView.settings.updateOnTouch = false
            } else {
                ratingStarCosmosView.rating = 1
                ratingStarCosmosView.settings.updateOnTouch = false
            }
            
            if allRating?.opinion != nil {
                opinionLabel.text = allRating?.opinion
            } else {
                opinionLabel.isHidden = true
            }
            
            if allRating?.time != nil {
                dateLabel.text = allRating?.time
            } else {
                dateLabel.isHidden = true
            }
            
            customrServiceResponse.isHidden = false
            if allRating?.ratingStatus != 2 {
                customrServiceResponse.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
