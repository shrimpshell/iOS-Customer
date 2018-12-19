//
//  BookingCheckTableViewCell.swift
//  iOS-Customer
//
//  Created by HUNG-HSUN LIN on 2018/11/30.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

protocol BookingCheckTableViewCellDelegate : class {
    func minusRoomQuantity(_ sender: BookingCheckTableViewCell)
    func plusRoomQuantity(_ sender: BookingCheckTableViewCell)
    func extraBedSwitchPressed(_ sender: BookingCheckTableViewCell)
}

class BookingCheckTableViewCell: UITableViewCell {
    
    @IBOutlet weak var roomTypeNameLabel: UILabel!
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var extraBedLabel: UILabel!
    @IBOutlet weak var extraBedSwitch: UISwitch!
    @IBOutlet weak var roomQuantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var totalDaysLabel: UILabel!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    weak var delegate: BookingCheckTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func minusRoomQuantity(_ sender: UIButton) {
        delegate?.minusRoomQuantity(self)
    }
    
    @IBAction func plusRoomQuantity(_ sender: UIButton) {
        delegate?.plusRoomQuantity(self)
    }
    @IBAction func extraBedSwitchPressed(_ sender: UISwitch) {
        delegate?.extraBedSwitchPressed(self)
    }
}
