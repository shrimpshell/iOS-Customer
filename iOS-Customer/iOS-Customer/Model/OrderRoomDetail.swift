//
//  OrderRoomDetail.swift
//  iOS-Customer
//

//  Created by Josh Hsieh on 2018/11/20.

//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import Foundation


struct OrderRoomDetail: Codable {
    var roomNumber: String
    var roomReservationStatus: String
    var idRoomStatus: Int
    
    enum CodingKeys: String, CodingKey {
        case roomNumber = "roomNumber"
        case roomReservationStatus = "roomReservationStatus"
        case idRoomStatus = "idRoomStatus"

    }
}
