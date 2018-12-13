//
//  SocketProtocol.swift
//  iOS-Customer
//
//  Created by Josh Hsieh on 2018/12/10.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import Foundation
import Starscream

class SocketProtocol: WebSocketDelegate {
    
    var socket: WebSocket!
    
    func socketConnect() {
        socket.connect()
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("Item websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("Item websocket is disconnected: \(error!.localizedDescription)")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("Item got some text: \(text)")
        
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Item got some data: \(data.count)")
    }
    
    
}
