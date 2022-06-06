//
//  ContentView.swift
//  ChatroomSwiftUI
//
//  Created by Ken Yeh on 2022/6/1.
//

import SwiftUI

struct ContentView: View {
    
    @State var isLoginMode: Bool = false
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                Picker("picker view", selection: $isLoginMode) {
                    Text("Login")
                        .tag(true)
                    Text("Create Account")
                        .tag(false)
                }.pickerStyle(SegmentedPickerStyle())
                    .padding()
                
                Button(action: profileButtonPressed, label: {
                    Image(systemName: "person.fill")
                        .font(.system(size: 64))
                        .padding()
                })
                
                TextField("Email", text: $email)
                TextField("Password", text: $password)
                
                Button(action: loginButtonPressed, label: {
                    Text("Button")
                })
            }
            .navigationTitle("Create Account")
        }
    }
    
    func profileButtonPressed() {
        print("Porfile")
    }
    
    func loginButtonPressed() {
        print("Login")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
