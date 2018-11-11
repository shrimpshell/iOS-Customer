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
    
    var rating: Rating? {
        didSet {
            idRoomReservationLabel.text = "\(rating?.idRoomReservation)"
            ratingStar.rating = Double((rating?.ratingStar)!)
            opinionLabel.text = rating?.opinion
            reviewLabel.text = rating?.review
            timeLabel.text = rating?.time
            
            
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
