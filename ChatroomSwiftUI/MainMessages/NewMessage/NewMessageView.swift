//
//  NewMessageView.swift
//  ChatroomSwiftUI
//
//  Created by Ken Yeh on 2022/6/23.
//

import SwiftUI

struct NewMessageView: View {
    
    @Environment(\.presentationMode) var presentationMode
        
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(0..<10) { num in
                    Text("123")
                    Divider()
                }
            }
            .navigationTitle("New Message")
            .toolbar {
                ToolbarItemGroup(placement: ToolbarItemPlacement.navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        print("Cancel")
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
