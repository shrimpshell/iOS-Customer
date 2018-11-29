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
    
    func instantNotifications(text: String) {
        if UIApplication.shared.applicationState == .active {
          
            
        } else {
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "test"
            content.body = "test"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
            let request = UNNotificationRequest(identifier: "alert", content: content, trigger: trigger)
            center.add(request) { (error) in
            }
        }
    }
    
}
