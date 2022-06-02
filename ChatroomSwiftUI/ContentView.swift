//
//  ContentView.swift
//  ChatroomSwiftUI
//
//  Created by Ken Yeh on 2022/6/1.
//

import SwiftUI

struct ContentView: View {
    
    @State var isLoginMode: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                Picker("picker view", selection: $isLoginMode) {
                    Text("Login")
                    Text("Create Account")
                }.pickerStyle(SegmentedPickerStyle())
            }
            .navigationTitle("Create Account")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
