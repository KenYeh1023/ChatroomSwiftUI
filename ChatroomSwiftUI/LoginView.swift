//
//  ContentView.swift
//  ChatroomSwiftUI
//
//  Created by Ken Yeh on 2022/6/1.
//

import SwiftUI

struct LoginView: View {
    
    @State var isLoginMode: Bool = false
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    
                    Picker("picker view", selection: $isLoginMode) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    if !isLoginMode {
                        Button(action: profileButtonPressed, label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
                        })
                    }
                    
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        SecureField("Password", text: $password)
                    }
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(5)
                    
                    Button(action: loginButtonPressed, label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Log In" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }.background(Color.blue)
                        .cornerRadius(5)
                    })
                }
                .padding()
            }
            .background(Color(.init(white: 0, alpha: 0.05))
                            .ignoresSafeArea())
            .navigationTitle(isLoginMode ? "Log In" : "Create Account")
        }
    }
    
    func profileButtonPressed() {
        print("Porfile")
    }
    
    func loginButtonPressed() {
        if isLoginMode {
            print("Need Log in")
        } else {
            print("Create Account")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
