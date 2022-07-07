//
//  MainMessagesView.swift
//  ChatroomSwiftUI
//
//  Created by Ken Yeh on 2022/6/16.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

class MainMessagesViewModel: ObservableObject {
    
    @Published var message = ""
    @Published var chatUser: ChatUser?
    @Published var isUserCurrentlyLoggedOut = false
    @Published var recentMessages: [RecentMessage] = []
    
    private var firestoreListener: ListenerRegistration?
    
    init() {
        
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        
        fetchCurrentUser()
        fetchRecentMessages()
    }
    
    func fetchRecentMessages() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        firestoreListener?.remove()
        self.recentMessages.removeAll()
        
        firestoreListener = FirebaseManager.shared.firesotre
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Failed to Fetch Recent Message Due to \(error)")
                }
                querySnapshot?.documentChanges.forEach({ (change) in
                    let docId = change.document.documentID
                    if let index = self.recentMessages.firstIndex(where: { (recentMessage) in
                        return recentMessage.documentId == docId
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    self.recentMessages.insert(.init(documentId: change.document.documentID, data: change.document.data()), at: 0)
                })
        }
    }
    
    func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        FirebaseManager.shared.firesotre.collection("users").document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print("Failed to fetch data", error)
                return
            }
            
            guard let data = snapshot?.data() else { return }
            self.chatUser = .init(data: data)
        }
    }
    
    func handleSignOut() {
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
}

struct MainMessagesView: View {
    
    @State var chatUser: ChatUser?
    
    @State var shouldShowLogOutOptions: Bool = false
    
    @State var shouldNavigateToChatLogView: Bool = false
    
    @ObservedObject private var vm = MainMessagesViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                customNavBar
                messageView
                
                NavigationLink("", destination: ChatLogView(chatUser: self.chatUser), isActive: $shouldNavigateToChatLogView)
            }
            .navigationBarHidden(true)
            .overlay(newMessageButton, alignment: .bottom)
        }
    }

    
    func settingButtonPressed() {
        shouldShowLogOutOptions.toggle()
    }
    
    func fetchChatUser(message: RecentMessage) {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let chatUserId = uid == message.fromId ? message.toId : message.fromId
        
        self.chatUser = .init(data: ["email": message.email, "profileImageUrl": message.profileImageUrl, "uid": chatUserId])
    }
    
    private var messageView: some View {
        ScrollView {
            ForEach(vm.recentMessages) { message in
                VStack {
                    Button(action: {
                        fetchChatUser(message: message)
                        self.shouldNavigateToChatLogView.toggle()
                    }, label: {
                        HStack(spacing: 16) {
                            WebImage(url: URL(string: message.profileImageUrl))
                                .resizable()
                                .frame(width: 60, height: 60)
                                .scaledToFill()
                                .cornerRadius(30)
                                .overlay(RoundedRectangle(cornerRadius: 60)
                                            .stroke(Color(.label), lineWidth: 1)
                                )
                                .shadow(radius: 5)
                            VStack(alignment: .leading, spacing: 8) {
                                Text(message.userName)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(.label))
                                Text(message.text)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.lightGray))
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                                    .truncationMode(.tail)
                            }
                            Spacer()
                            Text(message.timeAgo)
                                .font(.system(size: 14, weight: .semibold))
                        }.padding(.vertical, 8)
                        Divider()
                    })
                }.padding(.horizontal)
            }
        }.padding(.bottom, 50)
    }
        
    private var customNavBar: some View {
        VStack {
            HStack(spacing: 16) {
                WebImage(url: URL(string: vm.chatUser?.profileImageUrl ?? ""))
                    .resizable()
                    .frame(width: 44, height: 44)
                    .scaledToFill()
                    .cornerRadius(22)
                    .overlay(RoundedRectangle(cornerRadius: 44).stroke(Color(.label), lineWidth: 1))
                    .shadow(radius: 5)
                VStack(alignment: .leading, spacing: 4) {
                    let email = vm.chatUser?.userName ?? ""
                    Text(email)
                        .font(.system(size: 24, weight: .bold))
                    HStack {
                        Circle()
                            .foregroundColor(.green)
                            .frame(width: 12, height: 12)
                        Text("Online")
                            .font(.system(size: 12))
                            .foregroundColor(Color(.lightGray))
                    }
                }
                Spacer()
                Button(action: settingButtonPressed, label: {
                    Image(systemName: "gear")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(.label))
                })
            }
            .padding()
            .actionSheet(isPresented: $shouldShowLogOutOptions) {
                ActionSheet.init(title: Text("Settings"), message: Text("What to do Now?"), buttons: [
                    .destructive(Text("Sign Out"), action: {
                        print("Handle Sign out")
                        vm.handleSignOut()
                    }),
                    .cancel()
                ])
            }
            .fullScreenCover(isPresented: $vm.isUserCurrentlyLoggedOut, onDismiss: nil, content: {
                LoginView(didCompleteLoginProcess: {
                    self.vm.isUserCurrentlyLoggedOut = false
                    self.vm.fetchCurrentUser()
                    self.vm.fetchRecentMessages()
                })
            })
        }
    }
    
    @State var shouldShowNewMessageScreen: Bool = false
    
    private var newMessageButton: some View {
        Button(action: {
            shouldShowNewMessageScreen.toggle()
        }, label: {
        HStack {
            Spacer()
            Text("+ New Message")
                .font(.system(size: 16, weight: .bold))
            Spacer()
        }
        .foregroundColor(.white)
        .padding(.vertical)
        .background(Color.blue)
        .cornerRadius(32)
        .shadow(radius: 15)
        .padding(.horizontal)
        })
        
        .fullScreenCover(isPresented: $shouldShowNewMessageScreen, onDismiss: nil, content: {
            NewMessageView(didSelectNewUser: { user in
                shouldNavigateToChatLogView.toggle()
                self.chatUser = user
            })
        })
    }
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
