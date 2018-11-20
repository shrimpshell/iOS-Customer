//
//  PayDetail.swift
//  iOS-Customer
//
//  Created by Josh Hsieh on 2018/11/19.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import Foundation


struct PayDetail: Codable {
    var idRoomReservation: Int
    var checkInDate: String
    var checkOuntDate: String
    var roomNumber: String
    var price: String
    var roomQuantity: String
    var roomTypeName: String
    var roomReservationStatus: String
    var roomGroup: String
    var ratingStatus: String
    
//    init(idRoomReservation: Int, roomGroup: String, checkInDate: String, checkOuntDate: String, roomNumber: String, price: String, roomQuantity: String, RoomTypeName: String, roomReservationStatus: String, ratingStatus: String) {
//        self.idRoomReservation = idRoomReservation
//        self.checkInDate = checkInDate
//        self.checkOuntDate = checkOuntDate
//        self.roomNumber = roomNumber
//        self.price = price
//        self.roomQuantity = roomQuantity
//        self.roomTypeName = RoomTypeName
//        self.roomReservationStatus = roomReservationStatus
//        self.roomGroup = roomGroup
//        self.ratingStatus = ratingStatus
//    }
    
    enum CodingKeys: String, CodingKey {
        case idRoomReservation = "idRoomReservation"
        case checkInDate = "checkInDate"
        case checkOuntDate = "checkOuntDate"
        case roomNumber = "roomNumber"
        case price = "price"
        case roomQuantity = "roomQuantity"
        case roomTypeName = "roomTypeName"
        case roomReservationStatus = "roomReservationStatus"
        case roomGroup = "roomGroup"
        case ratingStatus = "ratingStatus"
    }
    
}
