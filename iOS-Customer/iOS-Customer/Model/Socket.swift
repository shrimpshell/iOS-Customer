//
//  Socket.swift
//  iOS-Customer
//
//  Created by Josh Hsieh on 2018/11/28.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import Foundation

struct Socket: Codable {
    var senderId: String
    var receiverId: String
    var senderGroupId: String
    var receiverGroupId: String
    var serviceId: Int
    var instantNumber: Int
    
    init(senderId: String, receiverId: String, senderGroupId: String, receiverGroupId: String, serviceId: Int, instantNumber: Int) {
        self.senderId = senderId
        self.receiverId = receiverId
        self.senderGroupId = senderGroupId
        self.receiverGroupId = receiverGroupId
        self.serviceId = serviceId
        self.instantNumber = instantNumber
    }
    
}
