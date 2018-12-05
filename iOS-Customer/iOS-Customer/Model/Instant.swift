//
//  Instant.swift
//  iOS-Customer
//
//  Created by Josh Hsieh on 2018/11/15.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import Foundation


struct Instant: Codable {
    var idInstantDetail: Int
    var idInstantService: Int
    var status: Int
    var quantity: Int
    var idInstantType: Int
    var idRoomStatus: Int
    var roomNumber: String
    
    
    init(idInstantDetail: Int, idInstantService: Int, status: Int, quantity: Int, idInstantType: Int, idRoomStatus: Int, roomNumber: String) {
        self.idInstantDetail = idInstantDetail
        self.idInstantService = idInstantService
        self.status = status
        self.quantity = quantity
        self.idInstantType = idInstantType
        self.idRoomStatus = idRoomStatus
        self.roomNumber = roomNumber
    }
    
    enum CodingKeys: String, CodingKey {
        case idInstantDetail = "IdInstantDetail"
        case idInstantService = "IdInstantService"
        case status = "Status"
        case quantity = "Quantity"
        case idInstantType = "IdInstantType"
        case idRoomStatus = "IdRoomStatus"
        case roomNumber = "RoomNumber"
    }
}


