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
    var name: String
    var roomSize: String
    var bed: String
    var adultQuantity: Int
    var childQuantity: Int
    var roomQuantity: Int
    var price: Int
}

struct Events: Codable {
    var discount: Float
}

struct ShoppingCar {
    var roomTypeName: String
    var checkInDate: String
    var checkOutDate: String
    var roomQuantity: Int
    var price: Int
}
