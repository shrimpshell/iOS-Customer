//
//  Download.swift
//  iOS-Customer
//
//  Created by Una Lee on 2018/11/11.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import Foundation
import Alamofire



let ACTION = "action"
let ID_CUSTOMER = "IdCustomer"
let CUSTOMER_KEY = "customer"
let RESULT_KEY = "result"
let DATA_KEY = "data"
let IDROOMRESERVATION_KEY = "IdRoomReservation"
//Instant_Keys
let ROOMNUMBER_KEY = "roomNumber"
let INSTANT_KEY = "instant"
let IDINSTANTDETAIL_KEY = "idInstantDetail"
let STATUS_KEY = "status"
let ID_INSTANTSERVICE_KEY = "idInstantService"
let ID_CUSTOMER_KEY = "idCustomer"


typealias DoneHandler = (_ result: Any?, _ error: Error?) -> Void


struct DownloadAuth {
    
    
    let RATING_SERVLET = Common.SERVER_URL + "/RatingServlet"
    let CUSTOMER_SERVLET = Common.SERVER_URL + "/CustomerServlet"
    let INSTANT_SERVLET = Common.SERVER_URL + "/InstantServlet"
    let PAYDETAIL_SERVLET = Common.SERVER_URL + "/PayDetailServlet"
    
    
    static let shared = DownloadAuth()
    
    private init(){
    }
    
    // MARK: - Rating
    
    func getAllRatingById(idCustomer: Int, completion: @escaping DoneHandler) {
         let parameters: [String : Any] = [ACTION: "getAllById",
                                                                 ID_CUSTOMER: idCustomer]
        doPost(urlString: RATING_SERVLET, parameters: parameters, completion: completion)
        
    }
    
    func getAllCustomerRatings(key: String, completion: @escaping DoneHandler) {
         let parameters: [String : Any] = [ACTION: key]
        doPost(urlString: RATING_SERVLET, parameters: parameters, completion: completion)
    }
    
    func getCustomerInfoById(idCustomer: Int, completion: @escaping DoneHandler) {
        let parameters: [String : Any] = [ACTION: "findById",
                                          ID_CUSTOMER: idCustomer]
        doPost(urlString: CUSTOMER_SERVLET, parameters: parameters, completion: completion)
    }
    
    func editCustomerInfo(customer: Customer, completion: @escaping DoneHandler) {
        let parameters: [String : Any] = [ACTION: "update",
                                                                CUSTOMER_KEY: customer]
         doPost(urlString: CUSTOMER_SERVLET, parameters: parameters, completion: completion)
    }
    
    func getRatingStatus(idRoomReservation: Int, completion: @escaping DoneHandler) {
        let parameters: [String : Any] = [ACTION: "getRatingStatus", IDROOMRESERVATION_KEY: idRoomReservation]
        
        doPost(urlString: RATING_SERVLET, parameters: parameters, completion: completion)
    }
    
    // MARK: - InstantService
    // get user InstantService status
    func getCustomerStatus(roomNumber: String, completion: @escaping DoneHandler) {
        let parameters: [String : Any] = [ACTION: "getCustomerStatus", ROOMNUMBER_KEY: roomNumber]
        
        doPost(urlString: INSTANT_SERVLET, parameters: parameters, completion: completion)
    }
    
    func getEmployeeStatus(idInstantService: Int, completion: @escaping DoneHandler) {
        let parameters: [String : Any] = [ACTION: "getEmployeeStatus", ID_INSTANTSERVICE_KEY: idInstantService]
        
        doPost(urlString: INSTANT_SERVLET, parameters: parameters, completion: completion)
    }
    
    // add new InstantService  Alamorefire 不吃 物件 改為 string
    func insertInstant(instant: String, completion: @escaping DoneHandler) {
        let parameters: [String : Any] = [ACTION: "insertInstant", INSTANT_KEY: instant]
        
        
        doPost(urlString: INSTANT_SERVLET, parameters: parameters, completion: completion)
    }
    
    // update InstantServcice Status
    func updateStatus(idInstantDetail: Int, status: Int, completion: @escaping DoneHandler) {
        let parameters: [String : Any] = [ACTION: "updateStatus", IDINSTANTDETAIL_KEY: idInstantDetail, STATUS_KEY: status]
        
        doPost(urlString: INSTANT_SERVLET, parameters: parameters, completion: completion)
    }
    
    // get user roomNumber
    func getUserRoomNumber(idCustomer: String, completion: @escaping DoneHandler) {
        let parameters: [String : Any] = [ACTION: "getUserRoomNumber", ID_CUSTOMER_KEY: idCustomer]
        
        doPost(urlString: PAYDETAIL_SERVLET, parameters: parameters, completion: completion)
    }
    
    
    fileprivate func doPost(urlString: String,
                            parameters: [String: Any],
                            completion: @escaping DoneHandler) {

        
        Alamofire.request(urlString, method: HTTPMethod.post , parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            self.handleJSON(response: response, completion: completion)
        }
    }
        
        private func handleJSON(response: DataResponse<Any>, completion: DoneHandler) {
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

