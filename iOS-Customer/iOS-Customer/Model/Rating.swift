//
//  RatingClass.swift
//  iOS-Customer
//
//  Created by Una Lee on 2018/10/10.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import Foundation

class Rating {     //不確定要用struct還是用class
    var idRating: Int
    var ratingStar: Float
    var time: String
    var opinion: String
    var review: String
    var idRoomReservation: Int
    
    init(idRating: Int, ratingStar: Float, time: String, opinion: String, review: String, idRoomReservation: Int) {
        self.idRating = idRating
        self.ratingStar = ratingStar
        self.time = time
        self.opinion = opinion
        self.review = review
        self.idRoomReservation = idRoomReservation
        
    }
}


