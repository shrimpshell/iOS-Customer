//
//  Toast.swift
//  LogIn Progject
//
//  Created by Una Lee on 2018/12/16.
//  Copyright © 2018 Una Lee. All rights reserved.
//

import UIKit

extension UIViewController {

    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 150, y: view.frame.size.height-100, width: 300, height: 30))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.1
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
