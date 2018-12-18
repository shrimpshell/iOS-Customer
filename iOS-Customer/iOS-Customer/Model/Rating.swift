//
//  RatingClass.swift
//  iOS-Customer
//
//  Created by Una Lee on 2018/10/10.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import Foundation
import PromiseKit

struct Rating: Codable {
    var idCustomer: Int? = nil
    var idRating: Int? = nil
    var ratingStar: Float
    var time: String
    var opinion: String
    var review: String? = nil
    var idRoomReservation: Int
    var ratingStatus: Int
    var name: String? = nil
    
    init(idCustomer: Int? = nil, idRating: Int? = nil, ratingStar: Float, time: String, opinion: String, review : String? = nil, ratingStatus: Int, idRoomReservation: Int , name: String? = nil) {
        self.idCustomer = idCustomer
        self.idRating = idRating
        self.ratingStar = ratingStar
        self.time = time
        self.opinion = opinion
//        self.review = review
        self.idRoomReservation = idRoomReservation
        self.ratingStatus = ratingStatus
//        self.name = name
        
    }
    
    enum CodingKeys: String, CodingKey {
        case idRating = "IdRating"
        case idRoomReservation = "IdRoomReservation"
        case idCustomer = "IdCustomer"
        case ratingStar = "ratingStar"
        case time = "time"
        case opinion = "opinion"
        case review = "review"
        case ratingStatus = "ratingStatus"
        case name = "Name"
    }
}

struct RatingAuth: Codable {
    let SERVER_URL: String = Common.SERVER_URL
    let SERVLET: String = "/RatingServlet"

    func insertRating  (_ params: [String: Any]) -> Promise<String> {
        let completeURL = SERVER_URL + SERVLET
        let url = URL.init(string: completeURL)
        var request = URLRequest(url: url!)
        var idRating = "0"
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)

        return Promise { result in
            URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                guard let data = data, error == nil else {
                    return result.reject(error!)
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for
                    return result.reject("Status: \(httpStatus.statusCode)" as! Error)
                }

                let validResult = String(data: data, encoding: .utf8)
                idRating = String(describing: validResult!)
                return result.resolve(idRating, nil)
                }.resume()
            }
        }
}




