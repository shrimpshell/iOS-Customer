//
//  Event.swift
//  Event
//
//  Created by Lucy on 2018/11/14.
//  Copyright © 2018 Lucy. All rights reserved.
//

import Foundation

struct Event: Codable {//建立struct Event格式化資料使用,須參考JSON結構來定義
    var eventId: Int
    var discount: Double
    var name: String
    var description: String
    var start: String
    var end: String
}
