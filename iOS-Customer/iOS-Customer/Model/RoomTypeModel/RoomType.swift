//
//  RoomType.swift
//  iOS-Customer
//
//  Created by HUNG-HSUN LIN on 2018/11/14.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import Foundation



struct RoomType: Codable {
    var id: Int
    var name: String = ""
    var roomSize: String = ""
    var bed: String = ""
    var adultQuantity: Int = 0
    var childQuantity: Int = 0
    var roomQuantity: Int
    var price: Int = 0
}

struct Reservation: Codable {
    var reservationDate: String = ""
    var checkInDate: String = ""
    var checkOutDate: String = ""
    var extraBed: Int = 0
    var quantity: Int = 0
    var reservationStatus: String = "0"
    var customerId: Int = 0
    var roomTypeId: Int = 0
    var eventId: Int = 0
    var roomGroup: String = ""
    var price: Int = 0
    var reservationQuantity: Int = 0
    
    init(reservationDate: String = "", checkInDate: String = "", checkOutDate: String = "", extraBed: Int = 0, quantity: Int = 0, reservationStatus: String = "0", customerId: Int = 0, roomTypeId: Int = 0, eventId: Int = 0, roomGroup: String = "", price: Int = 0, reservationQuantity: Int = 0) {
        self.reservationDate = reservationDate
        self.checkInDate = checkInDate
        self.checkOutDate = checkOutDate
        self.extraBed = extraBed
        self.quantity = quantity
        self.reservationStatus = reservationStatus
        self.customerId = customerId
        self.roomTypeId = roomTypeId
        self.eventId = eventId
        self.roomGroup = roomGroup
        self.price = price
        self.reservationQuantity = reservationQuantity
    }
}

struct Events: Codable {
    var eventId: Int = 0
    var discount: Float = 0.0
}

struct ShoppingCar {
    var id: Int
    var roomTypeName: String
    var checkInDate: String
    var checkOutDate: String
    var roomQuantity: Int
    var eventId: Int = 0
    var price: Int
    
    init(id: Int, roomTypeName: String, checkInDate: String, checkOutDate: String, roomQuantity: Int, eventId: Int = 0, price: Int) {
        self.id = id
        self.roomTypeName = roomTypeName
        self.checkInDate = checkInDate
        self.checkOutDate = checkOutDate
        self.roomQuantity = roomQuantity
        self.eventId = eventId
        self.price = price
    }
}
