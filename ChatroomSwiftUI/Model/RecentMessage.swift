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
    
    var userName: String {
        return email.components(separatedBy: "@").first ?? self.email
    }
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp.dateValue(), relativeTo: Date())
    }
    
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
