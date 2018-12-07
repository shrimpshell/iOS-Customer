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
    var reservationStatus: String = ""
    var customerId: Int = 0
    var roomTypeId: Int = 0
    var eventId: Int = 0
    var roomGroup: String = ""
    var price: Int = 0
}

struct Events: Codable {
    var discount: Float
}

struct ShoppingCar {
    var id: Int
    var roomTypeName: String
    var checkInDate: String
    var checkOutDate: String
    var roomQuantity: Int
    var price: Int
}
