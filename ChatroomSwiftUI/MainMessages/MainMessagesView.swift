//
//  MainMessagesView.swift
//  ChatroomSwiftUI
//
//  Created by Ken Yeh on 2022/6/16.
//

import SwiftUI

struct MainMessagesView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(0..<10, id: \.self) { num in
                    HStack {
                        Image(systemName: "person.fill")
                            .font(.system(size: 32))
                        VStack(alignment: .leading) {
                            Text("User Name")
                            Text("Hello from the other side")
                        }
                        Spacer()
                        Text("22d")
                    }
                    Divider()
                }
            }
            .navigationTitle("Navigation Title")
        }
    }
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
