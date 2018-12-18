//
//  Alert.swift
//  iOS-Customer
//
//  Created by Una Lee on 2018/11/8.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit
import UserNotifications
import Starscream

extension UIViewController {
    
    func showAlert(title: String? = nil, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func showUserNotifications() {
        
        let content = UNMutableNotificationContent()
        content.title = "即時服務通知"
        content.subtitle = "subtitle"
        content.body = "body"
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "alert", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

    }

}


