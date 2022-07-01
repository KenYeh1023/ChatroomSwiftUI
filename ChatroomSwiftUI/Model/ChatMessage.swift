//
//  ChatMessage.swift
//  ChatroomSwiftUI
//
//  Created by Ken Yeh on 2022/7/1.
//

import Foundation

struct ChatMessage {
    
    let fromId: String
    let toId: String
    let text: String
    let timeStamp: String
    
    init(data: [String: Any]) {
        self.fromId = data["fromId"] as? String ?? ""
        self.toId = data["toId"] as? String ?? ""
        self.text = data["text"] as? String ?? ""
        self.timeStamp = data["timeStamp"] as? String ?? ""
    }
}
