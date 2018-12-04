//
//  UIImage+Resize.swift
//  PushMessage
//
//  Created by Una Lee on 2018/10/26.
//  Copyright © 2018 Una Lee. All rights reserved.
//

import UIKit

extension UIImage {
    
    // Check if it is necessary to resize.
    func resize(maxEdge: CGFloat) -> UIImage? {
        guard size.width > maxEdge || size.height > maxEdge
            else {
            return self
        }
        
        // Decide final size.
        let finalSize: CGSize
        if size.width >= size.height {
            let ratio = size.width / maxEdge
            finalSize = CGSize(width: maxEdge, height: size.height / ratio)
        } else {        //hieght > width
            let ratio = size.height / maxEdge
            finalSize = CGSize(width: size.width / ratio, height: maxEdge)
        }
        
        // Generate a new image.
        UIGraphicsBeginImageContext(finalSize)
        let rect = CGRect(x: 0, y: 0, width: finalSize.width, height: finalSize.height)
        self.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()       // Important!   東西要釋放，不然會掛掉
        return result
    }
}
