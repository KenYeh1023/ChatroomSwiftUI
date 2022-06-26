//
//  ChatUser.swift
//  ChatroomSwiftUI
//
//  Created by Ken Yeh on 2022/6/22.
//

import Foundation

struct ChatUser: Identifiable {
    
    var id: String { uid }
    
    let uid: String
    let email: String
    let profileImageUrl: String
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
    }
}
