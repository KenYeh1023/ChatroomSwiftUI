//
//  Utils.swift
//  ChatroomSwiftUI
//
//  Created by Ken Yeh on 2022/6/21.
//

import Foundation
import Firebase

class FirebaseManager: NSObject {
    
    let auth: Auth
    let storage: Storage
    let firesotre: Firestore
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firesotre = Firestore.firestore()
        super.init()
    }
}
