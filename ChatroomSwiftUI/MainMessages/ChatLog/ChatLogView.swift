//
//  ChatLogView.swift
//  ChatroomSwiftUI
//
//  Created by Ken Yeh on 2022/6/28.
//

import SwiftUI

struct ChatLogView: View {
    
    let chatUser: ChatUser?
    
    var body: some View {
        ScrollView {
            ForEach (0..<10) { num in
                Text("Fake Message View")
            }
        }.navigationTitle(chatUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        ChatLogView(chatUser: nil)
    }
}
