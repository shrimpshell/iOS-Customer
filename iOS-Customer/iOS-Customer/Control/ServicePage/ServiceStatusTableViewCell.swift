//
//  ServiceStatusTableViewCell.swift
//  iOS-Customer
//
//  Created by Josh Hsieh on 2018/11/15.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

class ServiceStatusTableViewCell: UITableViewCell {

    @IBOutlet weak var statusImage: UIImageView!
    
    @IBOutlet weak var statusLabelForInstantService: UILabel!
    
    @IBOutlet weak var statusLabelForServiceType: UILabel!
    
    @IBOutlet weak var statusLabelForCount: UILabel!
    
    @IBOutlet weak var statusView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        statusView.layer.cornerRadius = 20
        statusView.layer.shadowOffset = CGSize(width: 5, height: 5)
        statusView.layer.shadowOpacity = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
