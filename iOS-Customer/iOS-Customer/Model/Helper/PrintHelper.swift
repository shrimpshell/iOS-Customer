//
//  printHelper.swift
//  iOS-Customer
//
//  Created by Una Lee on 2018/11/14.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

// 範例
// 在 improt 底下建立 TAG
// let TAG = "ProductPageViewController"
// printHelper.println(tag: TAG, line: #line, "MAG")
// 輸出結果
// 在 ProductPageViewController 的 50 行,
// 訊息：MAG

import Foundation

final class printHelper {
    static func println(tag: String, line: Int, _ msg: String) {
        print("在 \(tag) 的 \(line) 行,\n訊息：\(msg) ")
    }
}
