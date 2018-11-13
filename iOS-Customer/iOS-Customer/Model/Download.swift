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


typealias DoneHandler = (_ result:[Any]?, _ error: Error?) -> Void

struct DownloadAuth {
    //static let SERVER_URL = "http://192.168.1.2:8080/ShellService"
   static let SERVER_URL = "http://192.168.50.105:8080/ShellService"
    let RATING_SERVLET = SERVER_URL + "/RatingServlet"
    let CUSTOMER_SERVLET = SERVER_URL + "/CustomerServlet"
    
    
    
    static let shared = DownloadAuth()
    
    private init(){
    }
    
    func getAllRatingById(idCustomer: Int, completion: @escaping DoneHandler) {
         let parameters: [String : Any] = [ACTION: "getAllById",
                                                                 ID_CUSTOMER: idCustomer]
        doPost(urlString: RATING_SERVLET, parameters: parameters, completion: completion)
        
    }
    
    func getCustomerInfoById(idCustomer: Int, completion: @escaping DoneHandler) {
        let parameters: [String : Any] = [ACTION: "findById",
                                          ID_CUSTOMER: idCustomer]
        doPost(urlString: CUSTOMER_SERVLET, parameters: parameters, completion: completion)
    }
    
    func editCustomerInfo(customer: Customer, completion: @escaping DoneHandler) {
        let parameters: [String : Any] = [ACTION: "update",
                                                                CUSTOMER_KEY: customer.dictionaryRepresentation]
         doPost(urlString: CUSTOMER_SERVLET, parameters: parameters, completion: completion)
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
                guard let finalJson = json as? [ Any] else {
                    let error = NSError(domain: "Invalid JSON object.", code:-1, userInfo: nil)
                    completion(nil, error)
                    return
                }
                completion(finalJson, nil)
            case .failure(let error):
                print("Server respond error: \(error)")
                completion(nil, error)
            }
        }
}
