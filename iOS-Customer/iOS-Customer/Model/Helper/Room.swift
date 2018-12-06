//
//  Room.swift
//  Employee
//
//  Created by Lucy on 2018/11/8.
//  Copyright © 2018 Lucy. All rights reserved.
//

import UIKit

struct Room: Codable {//建立struct Room格式化資料使用,須參考JSON結構來定義
    var id: Int
    var name: String
    var roomSize: String
    var bed: String
    var adultQuantity: Int
    var childQuantity: Int
    var roomQuantity: Int
    var price: Int
//    var roomPic: UIImage
    
}

typealias DownloadDoneHandler = ([Room]?, Error?) -> Void//closure取別名

class RoomDownloaderAndUploader {
    
    //取得所有房型資料
    class func downloadRoom(url: URL, doneHandler: @escaping DownloadDoneHandler) {//class method
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Download fail: \(error)")
                return
            }
            
            guard let data = data else {
                assertionFailure("data is nil.")
                return
            }
            //開始解析資料
            guard let items = parseJSON(data: data) else {
                print("Parse nil.")
                DispatchQueue.main.async {
                    doneHandler(nil, error)
                }
                return
            }
            
            print("Parse OK.")
            DispatchQueue.main.async {
                doneHandler(items, nil)
            }
        }
        task.resume()
    }
    
    private class func parseJSON(data: Data) -> [Room]? {
        let decoder = JSONDecoder()
        var results: [Room]? = nil
        
        do {
            results = try decoder.decode([Room].self, from: data)
            print("Parse OK: \(results!)")
        } catch  {
            assertionFailure("Parse Fail: \(error)")
        }
        
        return results
    }
}
