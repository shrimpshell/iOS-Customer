//
//  Communicator.swift
//  iOS-Customer
//
//  Created by Una Lee on 2018/11/6.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import Foundation

class Communicator {
    static let BASEURL = "http://10.0.2.2:8080/ShellService"
    let JOIN_URL = BASEURL + "/CustomerServlet"
    
    static let shared = Communicator()
    
    private init() {
    }
    
//    func joinCustomer(<#parameters#>) -> <#return type#> {
//        <#function body#>
//    }
}
