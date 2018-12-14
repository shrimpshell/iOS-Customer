//
//  CheckInInfo.swift
//  iOS-Customer
//
//  Created by Una Lee on 2018/12/13.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import Foundation

struct CheckInInfo: Codable {
    var idCustomer: Int
    var checkInDate: String? = nil
    var roomNumber: String? = nil
    var roomReservationStatus: String? = nil
    
    init(idCustomer: Int, checkInDate: String? = nil, roomNumber: String? = nil, roomReservationStatus: String? = nil) {
        self.idCustomer = idCustomer
        self.checkInDate = checkInDate
        self.roomNumber = roomNumber
        self.roomReservationStatus = roomReservationStatus
    }
    
    enum CodingKeys: String, CodingKey {
        case idCustomer = "IdCustomer"
        case checkInDate = "CheckInDate"
        case roomNumber = "RoomNumber"
        case roomReservationStatus = "RoomReservationStatus"
    }
}


