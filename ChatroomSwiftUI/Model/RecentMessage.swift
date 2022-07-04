//
//  RecentMessage.swift
//  ChatroomSwiftUI
//
//  Created by Ken Yeh on 2022/7/4.
//

import Foundation
import Firebase

struct RecentMessage: Identifiable {
    
    var id: String { documentId }
    
    let documentId: String
    let fromId: String
    let toId: String
    let text: String
    let email: String
    let profileImageUrl: String
    let timestamp: Timestamp
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        
        self.fromId = data["fromId"] as? String ?? ""
        self.toId = data["toId"] as? String ?? ""
        self.text = data["text"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
    }
}
