//
//  Helper.swift
//  iOS-Customer
//
//  Created by Nick Wen on 2018/12/2.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//
// 範例
// 在 class 內建立 全域變數 TAG
// let TAG = "XXXViewController"
// LogHelper.println(tag: TAG, line: #line, "MAG")

// 輸出結果
// 在 XXXViewController 的 50 行,
// 訊息：MAG

import Foundation

final class Helper {
    static func println(tag: String, line: Int, _ msg: String) {
        print("在 \(tag) 的 \(line) 行,\n訊息：\(msg)\n")
    }
    
    // 依傳入的日期格式、日期轉換成日期
    // - Parameters:
    //   - strFormat: 日期格式,ex:"yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd"
    //   - strDate: 日期
    // - Returns: Date
    // - Example: Common.getDateFromString(strFormat: "yyyy-MM-dd", strDate: "2018-11-23")  >> 2018-11-23 00:00:00 +0000
    static func getDateFromString(strFormat: String, strDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strFormat
        dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "zh_TW")
        return dateFormatter.date(from: strDate)!
    }
    
    // 依傳入的日期格式、日期轉換成字串
    // - Parameters:
    //   - strFormat: 日期格式
    //   - date: 日期(Date)
    // - Returns: String
    static func getStringFromDate(strFormat: String, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strFormat
        dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "zh_TW")
        return dateFormatter.string(from: date)
    }
}
