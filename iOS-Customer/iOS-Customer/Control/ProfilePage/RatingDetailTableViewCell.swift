//
//  RatingDetailTableViewCell.swift
//  iOS-Customer
//
//  Created by Una Lee on 2018/11/9.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit
import Cosmos

class RatingDetailTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var idRoomReservationLabel: UILabel!
    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var opinionLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var reviewNameLabel: UILabel!
    var rating: Rating? {
        didSet {
            
            guard  let idRoomReservation = rating?.idRoomReservation else {
                print("Rating idRoomReservation is nil")
                return
            }
            if rating?.idRoomReservation != nil {
                idRoomReservationLabel.text = "\(idRoomReservation)"
            } else {
                idRoomReservationLabel.text = ""
            }
            
            if rating?.ratingStar != nil {
                ratingStar.rating = Double((rating?.ratingStar)!)
            } else {
                ratingStar.rating = 0
            }
            
            if rating?.opinion != nil {
                opinionLabel.text = rating?.opinion
            } else {
                opinionLabel.isHidden = true
            }
         
            if rating?.review != nil {
                reviewLabel.text = rating?.review
            } else {
                reviewLabel.isHidden = true
                reviewNameLabel.isHidden = true
            }
            
            if rating?.time != nil {
                timeLabel.text = rating?.time
            } else {
                timeLabel.isHidden = true
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
