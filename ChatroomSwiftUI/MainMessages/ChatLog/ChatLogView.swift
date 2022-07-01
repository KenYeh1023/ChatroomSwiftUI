//
//  ChatLogView.swift
//  ChatroomSwiftUI
//
//  Created by Ken Yeh on 2022/6/28.
//

import SwiftUI
import Firebase

class ChatLogViewModel: ObservableObject {
    
    @Published var chatText: String = ""
    @Published var errorMessage: String = ""
    
    @Published var chatMessages = [ChatMessage]()
    
    let chatUser: ChatUser?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        
        fetchMessages()
    }
    
    private func fetchMessages() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else { return }
        FirebaseManager.shared.firesotre.collection("messages").document(fromId).collection(toId).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                self.errorMessage = "Failed to Fetch Messages Data, \(error)"
                return
            }
            querySnapshot?.documents.forEach({ (queryDocumentSnapshot) in
                let data = queryDocumentSnapshot.data()
                self.chatMessages.append(.init(data: data))
            })
            
        }
    }
    
    func handleSend() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else { return }
        let document = FirebaseManager.shared.firesotre.collection("messages").document(fromId).collection(toId).document()
        let data: [String: Any] = ["fromId": fromId, "toId": toId, "text": chatText, "timeStamp": Timestamp()] as [String: Any]
        
        document.setData(data) { error in
            
            if let error = error {
                self.errorMessage = "Failed to Store Text Data, \(error)"
                return
            }
            self.chatText = ""
        }
        
        let recipientMessageDocument = FirebaseManager.shared.firesotre.collection("messages").document(toId).collection(fromId).document()
        
        recipientMessageDocument.setData(data) { error in
            
            if let error = error {
                self.errorMessage = "Failed to Store Text Data, \(error)"
                return
            }
        }
    }
}

struct ChatLogView: View {
    
    let chatUser: ChatUser?
    
    @ObservedObject var vm: ChatLogViewModel
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        self.vm = .init(chatUser: chatUser)
    }
    
    var body: some View {
        VStack {
            
            messagesView
            Text(vm.errorMessage)
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
            TextField("Descrpition", text: $vm.chatText)
            Button(action: {
                vm.handleSend()
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
        MainMessagesView()
//        NavigationView {
//            ChatLogView(chatUser: .init(data: ["email": "sixth@gmail.com", "uid": "YQTsynMd7RZp7dMiDk8Ski9qvGp1"]))
//        }
    }
}
