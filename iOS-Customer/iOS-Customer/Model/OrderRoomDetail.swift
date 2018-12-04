//
//  OrderRoomDetail.swift
//  iOS-Customer
//

//  Created by Josh Hsieh on 2018/11/20.

//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import Foundation
import PromiseKit


struct OrderRoomDetail {
    var checkInDate: String, checkOuntDate: String, roomNumber: String? = nil, price: String, roomQuantity: String, roomTypeName: String, roomReservationStatus: String, roomGroup: String, ratingStatus: String? = nil, idRoomReservation: Int
}

struct OrderInstantDetail: Codable {
    var instantTypeName: String?, quantity: String?, instantPrice: String?, roomGroup: String
}

struct OrderRoomDictionary {
    var id: String
    var orderRoomDetails: [OrderRoomDetail]
    var orderInstantDetails: [OrderInstantDetail]
}

struct OrderRoomDB {
    let SERVER_URL: String = Common.SERVER_URL
    let SERVLET: String = "/PayDetailServlet"
    
    func getRoomPayDetailById(_ params: [String:String]) -> Promise<[OrderRoomDetail]> {
        let completeURL = SERVER_URL + SERVLET
        let url = URL.init(string: completeURL)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        
        var orderRoomDetails = [OrderRoomDetail]()
        
        return Promise { result in
            URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                guard let data = data, error == nil else {
                    return result.reject(error!)
                }
                
                let jsonDataList = (try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves)) as! NSArray
                for element in jsonDataList {
                    let idRoomReservation = (element as! NSDictionary)["idRoomReservation"]
                    let checkInDate = (element as! NSDictionary)["checkInDate"]
                    let checkOuntDate = (element as! NSDictionary)["checkOuntDate"]
                    let price = (element as! NSDictionary)["price"]
                    let roomGroup = (element as! NSDictionary)["roomGroup"]
                    let roomNumber = (element as! NSDictionary)["roomNumber"] ?? nil
                    let roomQuantity = (element as! NSDictionary)["roomQuantity"]
                    let roomReservationStatus = (element as! NSDictionary)["roomReservationStatus"]
                    let roomTypeName = (element as! NSDictionary)["roomTypeName"]
                    let ratingStatus = (element as! NSDictionary)["ratingStatus"] ?? nil
                    
                    let orderRoomDetail: OrderRoomDetail = OrderRoomDetail(checkInDate: checkInDate as! String, checkOuntDate: checkOuntDate as! String, roomNumber: (roomNumber as? String) ?? nil, price: price as! String, roomQuantity: roomQuantity as! String, roomTypeName: roomTypeName as! String, roomReservationStatus: roomReservationStatus as! String, roomGroup: roomGroup as! String, ratingStatus: (ratingStatus as? String) ?? nil, idRoomReservation: idRoomReservation as! Int)
                    
                    orderRoomDetails.append(orderRoomDetail)
                }
                
                return result.resolve(orderRoomDetails, nil)
                }.resume()
        }
    }
    
    func getInstantPayDetail(_ params: [String:String]) -> Promise<[OrderInstantDetail]> {
        let completeURL = SERVER_URL + SERVLET
        let url = URL.init(string: completeURL)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        
        var orderInstantDetails = [OrderInstantDetail]()
        
        return Promise { result in
            URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                guard let data = data, error == nil else {
                    return result.reject(error!)
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    return result.reject("Status: \(httpStatus.statusCode)" as! Error)
                }
                
                let jsonDataList = (try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves)) as! NSArray
                for element in jsonDataList {
                    let instantTypeName = (element as! NSDictionary)["instantTypeName"] ?? nil
                    let quantity = (element as! NSDictionary)["quantity"] ?? nil
                    let instantPrice = (element as! NSDictionary)["instantPrice"] ?? nil
                    let roomGroup = (element as! NSDictionary)["roomGroup"]
                    
                    let orderInstantDetail: OrderInstantDetail = OrderInstantDetail(instantTypeName: instantTypeName as? String, quantity: quantity as? String, instantPrice: instantPrice as? String, roomGroup: roomGroup as! String)
                    
                    orderInstantDetails.append(orderInstantDetail)
                }
                
                return result.resolve(orderInstantDetails, nil)
                }.resume()
        }
    }
    
    func updateRoomReservationStatusById(_ params: [String: String]) -> Promise<String> {
        let completeURL = SERVER_URL + SERVLET
        let url = URL.init(string: completeURL)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        var status: String = ""
        
        return Promise { result in
            URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                guard let data = data, error == nil else {
                    return result.reject(error!)
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 { // check for http errors
                    return result.reject("Status: \(httpStatus.statusCode)" as! Error)
                }
                
                let id = String(data: data, encoding: .utf8)
                status = String(describing: id!)
                return result.resolve(status, nil)
                }.resume()
        }
    }
}
