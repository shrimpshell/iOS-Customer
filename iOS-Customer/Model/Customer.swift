//
//  Customer.swift
//  iOS-Customer
//
//  Created by Una Lee on 2018/10/10.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import Foundation

class  Customer {    //不確定要用struct還是用class
    var idCustomer: Int
    var customerID: String
    var name: String?
    var email: String?
    var password: String?
    var gender: String?
    var birthday: String?
    var phone: String?
    var address: String?
    var customerPic: Int?  //此處屬性要修改


    init (idCustomer: Int, customerID: String) {
        self.idCustomer = idCustomer
        self.customerID = customerID
      
    }
        
}
