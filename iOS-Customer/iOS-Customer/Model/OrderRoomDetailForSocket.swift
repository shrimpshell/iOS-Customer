//
//  OrderRoomDetailForSocket.swift
//  iOS-Customer
//
//  Created by Josh Hsieh on 2018/11/30.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import Foundation

struct OrderRoomDetailForSocket: Codable {
    var roomNumber: String
    var roomReservationStatus: String
    var idRoomStatus: Int
    
    enum CodingKeys: String, CodingKey {
        case roomNumber = "roomNumber"
        case roomReservationStatus = "roomReservationStatus"
        case idRoomStatus = "idRoomStatus"
        
    }
}
