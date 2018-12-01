//
//  RoomTypeCommunication.swift
//  iOS-Customer
//
//  Created by HUNG-HSUN LIN on 2018/11/14.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import Foundation
import Alamofire

class RoomTypeCommunicator {
    
    let ROOMTYPE_URL = Common.SERVER_URL + "/RoomTypeServlet"
    let EVENTS_URL = Common.SERVER_URL + "/EventServlet"
    let TAG = "RoomType"
    
    static let shared = RoomTypeCommunicator()
    private init() {
    }
    
    func getAllRoomType(completion: @escaping DoneHandler) {
        let parameters: [String: String] = [ACTION: "getAll"]
        
        doPost(urlString: ROOMTYPE_URL, parameters: parameters,
               completion: completion)
    }
    
    func getRoomType(checkInDate: String, checkOutDate: String, completion: @escaping DoneHandler) {
        let parameters: [String: String] = [ACTION: "getReservation", "checkInDate": checkInDate, "checkOutDate": checkOutDate]
        
        doPost(urlString: ROOMTYPE_URL, parameters: parameters,
               completion: completion)
    }
    
    func getEvent(checkInDate: String, completion: @escaping DoneHandler) {
        let parameters: [String: String] = [ACTION: "getDiscount", "firstday": checkInDate]
        
        doPost(urlString: EVENTS_URL, parameters: parameters,
               completion: completion)
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
