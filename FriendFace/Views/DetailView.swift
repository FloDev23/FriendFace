//
//  DetailUserView.swift
//  Challenge60
//
//  Created by Floriano Fraccastoro on 06/02/23.
//

import SwiftUI

import SwiftUI

struct DetailView: View {
    let user: CachedUser
    
    var body: some View {
        VStack {
            ZStack{
                Text(user.nameInitials ?? "XX")
                    .font(.largeTitle)
                    .padding(40)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(user.isActive ? Color.green : Color.gray, lineWidth: 4)
                    )
            }
            .frame(maxHeight: 150)
            
            List {
                Section {
                    Text("Registered: \(user.wrappedFormattedDate)")
                    Text("Age: \(user.age)")
                    Text("Email: \(user.wrappedEmail)")
                    Text("Address: \(user.wrappedAddress)")
                    Text("Works for: \(user.wrappedCompany)")
                } header: {
                    Text("Basic info")
                }
                
                Section {
                    Text(user.wrappedAbout)
                } header: {
                    Text("About")
                }
                
                Section {
                    ForEach(user.wrappedTags, id: \.self){
                        Text($0)
                    }
                } header: {
                    Text("Tags")
                }
                
                Section {
                    ForEach(user.friendsArray) { friend in
                        Text(friend.wrappedName)
                    }
                } header: {
                    Text("Friends")
                }
            }
        }
        .navigationTitle(user.wrappedName)
        .navigationBarTitleDisplayMode(.inline)
    }
}
