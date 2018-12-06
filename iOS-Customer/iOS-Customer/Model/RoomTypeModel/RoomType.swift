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
    var name: String? = nil
    var roomSize: String? = nil
    var bed: String? = nil
    var adultQuantity: Int? = nil
    var childQuantity: Int? = nil
    var roomQuantity: Int
    var price: Int? = nil
    
    init(id: Int, name: String? = nil, roomSize: String? = nil, bed: String? = nil, adultQuantity: Int? = nil, childQuantity: Int? = nil, roomQuantity: Int, price: Int? = nil) {
        self.id = id
        self.name = name
        self.roomSize = roomSize
        self.bed = bed
        self.adultQuantity = adultQuantity
        self.childQuantity = childQuantity
        self.roomQuantity = roomQuantity
        self.price = price
    }
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
