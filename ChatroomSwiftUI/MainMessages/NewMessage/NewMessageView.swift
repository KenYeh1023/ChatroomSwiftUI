//
//  NewMessageView.swift
//  ChatroomSwiftUI
//
//  Created by Ken Yeh on 2022/6/23.
//

import SwiftUI
import SDWebImageSwiftUI

class NewMessageViewModel: ObservableObject {
    
    @Published var users: [ChatUser] = []
    @Published var errorMessage: String = ""
    
    init() {
        fetchAllUsers()
    }
    
    private func fetchAllUsers() {
        FirebaseManager.shared.firesotre.collection("users").getDocuments { (documentSnapshot, error) in
            if let error = error {
                self.errorMessage = "Failed to get users, \(error)"
                return
            }
            
            documentSnapshot?.documents.forEach({ (snapshot) in
                let data = snapshot.data()
                let user = ChatUser(data: data)
                if user.uid != FirebaseManager.shared.auth.currentUser?.uid {
                    self.users.append(user)
                }
            })
        }
    }
}

struct NewMessageView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var vm = NewMessageViewModel()
        
    var body: some View {
        NavigationView {
            ScrollView {
                Text(vm.errorMessage)
                
                ForEach(vm.users) { user in
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        HStack(spacing: 16) {
                            WebImage(url: URL(string: user.profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(50)
                                .shadow(radius: 5)
                                .overlay(RoundedRectangle.init(cornerRadius: 32).stroke(Color(.label), lineWidth: 1))
                            Text(user.email)
                                .foregroundColor(Color(.label))
                            Spacer()
                        }.padding(.horizontal)
                    Divider()
                        .padding(.vertical)
                    })
                }
            }
            .navigationTitle("New Message")
            .toolbar {
                ToolbarItemGroup(placement: ToolbarItemPlacement.navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                    })
                }
            }
        }
    }
}

struct NewMessageView_Previews: PreviewProvider {
    static var previews: some View {
//        NewMessageView()
        MainMessagesView()
        
    }
}
