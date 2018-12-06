//
//  Event.swift
//  Event
//
//  Created by Lucy on 2018/11/14.
//  Copyright © 2018 Lucy. All rights reserved.
//

import Foundation

class Event {
    var Events_Name = ""
    var Events_Description = ""
    var discount:Float = 1.0
    var Events_Start_Datetime = ""
    var Events_End_Datetime = ""
    var image = ""
    
    init(Events_Name: String, Events_Description: String, discount: Float, Events_Start_Datetime: String, Events_End_Datetime: String, image: String) {
        self.Events_Name = Events_Name
        self.Events_Description = Events_Description
        self.discount = discount
        self.Events_Start_Datetime = Events_Start_Datetime
        self.Events_End_Datetime = Events_End_Datetime
        self.image = image
    }
}


