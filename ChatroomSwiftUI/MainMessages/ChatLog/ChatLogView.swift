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
    
    @Published var count: Int = 0
    
    let chatUser: ChatUser?
    
    var firestoreListener: ListenerRegistration?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        
        fetchMessages()
    }
    
    func fetchMessages() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else { return }
        firestoreListener = FirebaseManager.shared.firesotre.collection("messages").document(fromId).collection(toId).order(by: "timeStamp").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                self.errorMessage = "Failed to Fetch Messages Data, \(error)"
                return
            }
            
            querySnapshot?.documentChanges.forEach({ (change) in
                if change.type == .added {
                    let data = change.document.data()
                    self.chatMessages.append(.init(docId: change.document.documentID, data: data))
                }
            })
            
            DispatchQueue.main.async {
                self.count += 1
            }
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
            
            self.persistRecentMessage()
            
            self.chatText = ""
            self.count += 1
        }
        
        let recipientMessageDocument = FirebaseManager.shared.firesotre.collection("messages").document(toId).collection(fromId).document()
        
        recipientMessageDocument.setData(data) { error in
            
            if let error = error {
                self.errorMessage = "Failed to Store Text Data, \(error)"
                return
            }
        }
    }
    
    private func persistRecentMessage() {
        
        guard let chatUser = self.chatUser else { return }
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = self.chatUser?.uid else { return }
        
        let document = FirebaseManager.shared.firesotre.collection("recent_messages").document(uid).collection("messages").document(toId)
        
        let data: [String: Any]  = ["timestamp": Timestamp(), "text": self.chatText, "fromId": uid, "toId": toId, "email": chatUser.email, "profileImageUrl": chatUser.profileImageUrl] as [String: Any]
        
        document.setData(data) { error in
            
            if let error = error {
                self.errorMessage = "Failed to save recent message: \(error)"
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
        .onDisappear(perform: {
            vm.firestoreListener?.remove()
        })
    }
    
    private var messagesView: some View {
        ScrollView {
            ScrollViewReader { ScrollViewProxy in
                VStack {
                    ForEach (vm.chatMessages) { message in
                        MessageView(message: message)
                        }
                    HStack { Spacer() }
                        .id("down")
                .onReceive(vm.$count, perform: { _ in
                    withAnimation(.easeOut(duration: 0.5)) {
                        ScrollViewProxy.scrollTo("down", anchor: .bottom)
                        }
                    })
                }
            }
        }
        .background(Color(.init(white: 0.95, alpha: 1)))
    }
    
    private var charBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            ZStack {
                DiscriptionPlaceholder()
                TextEditor(text: $vm.chatText)
                    .opacity(vm.chatText.isEmpty ? 0.5 : 1)
            }
            .frame(height: 40)
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
    
    struct MessageView: View {
        
        var message: ChatMessage
        var body: some View {
            VStack {
                if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                    HStack {
                        Spacer()
                        HStack {
                            Text(message.text)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                } else {
                    HStack {
                        HStack {
                            Text(message.text)
                                .foregroundColor(Color(.label))
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }
    
    private struct DiscriptionPlaceholder: View {
        var body: some View {
            HStack {
                Text("Description")
                    .foregroundColor(Color(.gray))
                    .font(.system(size: 17))
                    .padding(.leading, 5)
                    .padding(.top, -4)
                Spacer()
            }
        }
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
