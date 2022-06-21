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
    
    @State var shouldShowImagwPicker: Bool = false
        
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
                            VStack {
                                if let image = self.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 128, height: 128)
                                        .cornerRadius(64)
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 64))
                                        .foregroundColor(.black)
                                        .padding()
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 64)
                                        .stroke(Color.black, lineWidth: 3)
                            )
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
                    
                    Text(loginStatusMessage)
                        .foregroundColor(.red)
                }
                .padding()
            }
            .background(Color(.init(white: 0, alpha: 0.05))
                            .ignoresSafeArea())
            .navigationTitle(isLoginMode ? "Log In" : "Create Account")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $shouldShowImagwPicker, onDismiss: nil, content: {
            ImagePicker(image: $image)
        })
    }
    
    @State var image: UIImage?
    
    func profileButtonPressed() {
        shouldShowImagwPicker.toggle()
        print("Porfile")
    }
    
    func loginButtonPressed() {
        if isLoginMode {
            loginUser()
        } else {
            creatUserAccount()
        }
    }
    
    @State var loginStatusMessage: String = ""
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                loginStatusMessage = "Account Log in Fail, \(error)"
                return
            }
            
            loginStatusMessage = "Account Log in Successfully, User: \(result?.user.uid ?? "")"
        }
    }
    private func creatUserAccount() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                loginStatusMessage = "Account Created Fail, \(error)"
                return
            }
            
            loginStatusMessage = "Account Created Successfully, User: \(result?.user.uid ?? "")"
            persistImageToStorage()
        }
    }
    
    private func persistImageToStorage() {
        guard let image = self.image?.jpegData(compressionQuality: 0.5) else { return }
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        
        ref.putData(image, metadata: nil) { (metadata, error) in
            if let error = error {
                loginStatusMessage = "Upload Profile Picture Failed, \(error)"
                return
            }
            
            ref.downloadURL { (url, error) in
                if let error = error {
                    loginStatusMessage = "Failed to Retrieve download Url, \(error)"
                    return
                }
                
                if let url = url {
                    loginStatusMessage = "Successfully Stored Image with Url: \(url.absoluteString)"
                    
                    storeUserInformation(profileImageUrl: url)
                }
            }
        }
    }
    
    private func storeUserInformation(profileImageUrl: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = ["email": self.email, "uid": uid, "profileImageUrl": profileImageUrl.absoluteString]
        FirebaseManager.shared.firesotre.collection("users").document(uid).setData(userData) { error in
            if let error = error {
                self.loginStatusMessage = "Store User Data Failed: \(error)"
                return
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
