//
//  ChatLogView.swift
//  ChatroomSwiftUI
//
//  Created by Ken Yeh on 2022/6/28.
//

import SwiftUI

struct ChatLogView: View {
    
    let chatUser: ChatUser?
    
    @State var chatText: String = ""
    
    var body: some View {
        VStack {
            
            messagesView
            
            charBottomBar
            
        }
        .navigationTitle(chatUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var messagesView: some View {
        ScrollView {
            ForEach (0..<10) { num in
                HStack {
                    Spacer()
                    HStack {
                        Text("Fake Message View")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            HStack { Spacer() }
        }
        .background(Color(.init(white: 0.95, alpha: 1)))
    }
    
    private var charBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            TextField("Descrpition", text: $chatText)
            Button(action: {
                print(chatText)
            }, label: {
                Text("Send")
                    .foregroundColor(.white)
            })
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.blue)
            .cornerRadius(4)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatLogView(chatUser: .init(data: ["email": "sixth@gmail.com", "uid": "YQTsynMd7RZp7dMiDk8Ski9qvGp1"]))
        }
    }
}
