//
//  Customer.swift
//  iOS-Customer
//
//  Created by Una Lee on 2018/10/10.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import Foundation
import PromiseKit

struct Customer: Codable {
    var idCustomer: Int
    //var customerID: String
    var name: String
    var email: String
    var password: String
    //var gender: String
    var birthday: String
    var phone: String
    var address: String
    var discount: Int

    enum CodingKeys: String, CodingKey {
        case idCustomer = "IdCustomer"
        //case customerID = "CustomerID"
        case name = "Name"
        case email = "Email"
        case password = "Password"
        //case gender = "Gender"
        case birthday = "Birthday"
        case phone = "Phone"
        case address = "Address"
        case discount = "discount"
    }
}
    
    struct CustomerAuth: Codable {
        let SERVER_URL: String = Common.SERVER_URL
        let SERVLET: String = "/CustomerServlet"
        
        func userExist (_ params: [String: String]) -> Promise<String> {
            let completeURL = SERVER_URL + SERVLET
            let url = URL.init(string: completeURL)
            var request = URLRequest(url: url!)
            var userExist = "false"
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
                    userExist = String(describing: validResult!)
                    return result.resolve(userExist, nil)
                    }.resume()
                }
            }
        
        func joinCustomer (_ params: [String: String]) -> Promise<String> {
            let completeURL = SERVER_URL + SERVLET
            let url = URL.init(string: completeURL)
            var request = URLRequest(url: url!)
            var isCustomerJoin = "false"
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
                    isCustomerJoin = String(describing: validResult!)
                    return result.resolve(isCustomerJoin, nil)
                    }.resume()
                }
            }
        
        func isValidUser(_ params: [String: String]) -> Promise<String> {
            let completeURL = SERVER_URL + SERVLET
            let url = URL.init(string: completeURL)
            var request = URLRequest(url: url!)
            var isValidAccount = "false"
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
                    isValidAccount = String(describing: validResult!)
                    return result.resolve(isValidAccount, nil)
                    }.resume()
                }
            }
        
        func isCorrectUser(_ params: [String: String]) -> Promise<String> {
            let completeURL = SERVER_URL + SERVLET
            let url = URL.init(string: completeURL)
            var request = URLRequest(url: url!)
            var idCustomer = "0"
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject: params)
            
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
                    idCustomer = String(describing: id!)
                    return result.resolve(idCustomer, nil)
                    }.resume()
                }
            }
        
    
    func getCustomerInfo(_ params: [String: String]) -> Promise<Customer?> {
        let completeURL = SERVER_URL + SERVLET
        let url = URL.init(string: completeURL)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        var receivedInfo: Customer? = nil
        
        return Promise { result in
            URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                guard let data = data, error == nil else {
                    return result.reject(error!)
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    return result.reject("Status: \(httpStatus.statusCode)" as! Error)
                }
                
                let decoder = JSONDecoder()
                receivedInfo = try? decoder.decode(Customer.self, from: data)
                return result.resolve(receivedInfo, nil)
                }.resume()
            }
        }
        
        func getCustomerImage(_ params: [String: Any]) -> Promise<Data?> {
            let completeURL = SERVER_URL + SERVLET
            let url = URL.init(string: completeURL)
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject: params)
            
            return Promise { result in
                URLSession.shared.dataTask(with: request) {
                    (data, response, error) in
                    guard let data = data, error == nil else {
                        return result.reject(error!)
                    }
                    return result.resolve(data, nil)
                    }.resume()
            }
        }
    }







