//
//  RoomTypeCommunication.swift
//  iOS-Customer
//
//  Created by HUNG-HSUN LIN on 2018/11/14.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import Foundation
import Alamofire

let ROOMTYPE_URL = Common.SERVER_URL + "/RoomTypeServlet"
let EVENTS_URL = Common.SERVER_URL + "/EventServlet"
let RESERVATION_URL = Common.SERVER_URL + "/ReservationServlet"
let RESERVATION_KEY = "reservation"

class RoomTypeCommunicator {
    
    let TAG = "RoomType"
    
    static let shared = RoomTypeCommunicator()
    private init() {
    }
    
    // MARK: - Gate data from servser.
    func doPostAllRoomType(completion: @escaping DoneHandler) {
        let parameters: [String: String] = [ACTION: "getAll"]
        
        doPost(urlString: ROOMTYPE_URL, parameters: parameters,
               completion: completion)
    }
    
    func doPostRoomType(checkInDate: String, checkOutDate: String, completion: @escaping DoneHandler) {
        let parameters: [String: String] = [ACTION: "getReservation", "checkInDate": checkInDate, "checkOutDate": checkOutDate]
        
        doPost(urlString: ROOMTYPE_URL, parameters: parameters,
               completion: completion)
    }
    
    func doPostEvent(checkInDate: String, completion: @escaping DoneHandler) {
        let parameters: [String: String] = [ACTION: "getDiscount", "firstday": checkInDate]
        
        doPost(urlString: EVENTS_URL, parameters: parameters,
               completion: completion)
    }
    
    func doPostRoomTypeQuantity(checkInDate: String, checkOutDate: String, roomTypeId: Int, completion: @escaping DoneHandler) {
        let parameters: [String: Any] = [ACTION: "findByRoomId", "checkInDate": checkInDate, "checkOutDate": checkOutDate, "roomTypeId": roomTypeId]
        
        doPost(urlString: ROOMTYPE_URL, parameters: parameters,
               completion: completion)
    }
    
    // MARK: - Insert new data to server.
    // Add new reservation.  Alamorefire just use jsonString.
    func insertReservation(reservation: String, completion: @escaping DoneHandler) {
        let parameters: [String : Any] = [ACTION: "insertReservation", RESERVATION_KEY: reservation]
        
        
        doPost(urlString: RESERVATION_URL, parameters: parameters, completion: completion)
    }
    
    // MARK: - Post data.
    
    private func doPost(urlString: String,
                        parameters: [String: Any],
                        completion: @escaping DoneHandler) {
        Alamofire.request(urlString, method: HTTPMethod.post, parameters: parameters,encoding: JSONEncoding.default).responseJSON { (response) in
            self.handleJSON(response: response, completion: completion)
        }
        
    }
    
    private func handleJSON(response: DataResponse<Any>,
                            completion: DoneHandler) {
        // result -> public enum
        switch response.result {
        case .success(let json):
            print("Get success response: \(json)")
            completion(json, nil)
            
        case .failure(let error):
            print("Server respond error: \(error)")
            
            completion(nil, error)
        }
    }
}
