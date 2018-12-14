//
//  ItemDetailTableViewCell.swift
//  iOS-Customer
//
//  Created by Josh Hsieh on 2018/11/15.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

class ItemDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemDetailImages: UIImageView!
    
    @IBOutlet weak var itemDetailLabel: UILabel!
    
    @IBOutlet weak var itemTextField: UITextField!
    
    @IBOutlet weak var itemView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        itemView.layer.cornerRadius = 20
        itemView.layer.shadowOffset = CGSize(width: 5, height: 5)
        itemView.layer.shadowOpacity = 5
        
       
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        
    }

    @IBAction func itemTextFiledBtn(_ sender: UITextField) {
        
    }
    
    
}
