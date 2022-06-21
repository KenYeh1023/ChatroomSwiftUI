//
//  MainMessagesView.swift
//  ChatroomSwiftUI
//
//  Created by Ken Yeh on 2022/6/16.
//

import SwiftUI

class MainMessagesViewModel: ObservableObject {
    
    init() {
       fetchCurrentUser()
    }
    
    private func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        FirebaseManager.shared.firesotre.collection("users").document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print("Failed to fetch data", error)
                return
            }
            
            guard let data = snapshot?.data() else { return }
            print(data)
        }
    }
}

struct MainMessagesView: View {
    
    @State var shouldShowLogOutOptions: Bool = false
    
    func settingButtonPressed() {
        shouldShowLogOutOptions.toggle()
    }
    
    private var messageView: some View {
        ScrollView {
            ForEach(0..<10, id: \.self) { num in
                VStack {
                    HStack(spacing: 16) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 32))
                            .padding(8)
                            .overlay(RoundedRectangle(cornerRadius: 44)
                                        .stroke(Color(.label), lineWidth: 1)
                            )
                        VStack(alignment: .leading) {
                            Text("User Name")
                                .font(.system(size: 16, weight: .bold))
                            Text("Hello from the other side")
                                .font(.system(size: 14))
                                .foregroundColor(Color(.lightGray))
                        }
                        Spacer()
                        Text("22d")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)
            }
        }.padding(.bottom, 50)
    }
    
    private var customNavBar: some View {
        VStack {
            HStack(spacing: 16) {
                Image(systemName: "person.fill")
                    .font(.system(size: 34, weight: .heavy))
                VStack(alignment: .leading, spacing: 4) {
                    Text("Pickachu")
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
                    }),
                    .cancel()
                ])
            }
            messageView
        }
    }
    
    private var newMessageButton: some View {
        Button(action: {}, label: {
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
    }
    
    var body: some View {
        NavigationView {
            customNavBar
            .navigationBarHidden(true)
            .overlay(newMessageButton, alignment: .bottom)
        }
    }
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
