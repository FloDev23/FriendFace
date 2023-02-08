//
//  ContentView.swift
//  Challenge60
//
//  Created by Floriano Fraccastoro on 06/02/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var cachedUsers: FetchedResults<CachedUser>
    
    @State private var users = [User]()
    @State private var sortText = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(cachedUsers){ user in
                    NavigationLink {
                        DetailView(user: user)
                    } label: {
                        HStack {
                            Text(user.nameInitials ?? "XX")
                                .padding()
                                .clipShape(Circle())
                                .frame(width: 70)
                                .overlay(
                                    Circle()
                                        .stroke(user.isActive ? Color.green : Color.gray, lineWidth: 2)
                                )
                                .padding([.top, .bottom, .trailing], 5)
                            VStack(alignment: .leading) {
                                Text(user.wrappedName)
                                    .font(.headline)
                                Text(user.isActive ? "Active" : "Offline")
                                    .font(.subheadline)
                                    .foregroundColor(user.isActive ? .green : .secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("FriendFace \(cachedUsers.count)")
            .listStyle(.plain)
            .task {
                if cachedUsers.isEmpty || cachedUsers.count < users.count{
                    await loadData()
                    
                    await MainActor.run {
                        for user in users {
                            let newUser = CachedUser(context: moc)
                            newUser.name = user.name
                            newUser.id = user.id
                            newUser.isActive = user.isActive
                            newUser.age = Int16(user.age)
                            newUser.about = user.about
                            newUser.email = user.email
                            newUser.address = user.address
                            newUser.company = user.company
                            newUser.formattedDate = user.formattedDate
                            newUser.tags = user.tags.joined(separator: ",")
                            
                            for friend in user.friends {
                                let newFriend = CachedFriend(context: moc)
                                newFriend.id = friend.id
                                newFriend.name = friend.name
                                newFriend.user = newUser
                            }
                            
                            try? moc.save()
                        }
                    }
                }
            }
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else{
            fatalError("URL Invalid")
        }
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedData = try? decoder.decode([User].self, from: data){
                users = decodedData
            }
        } catch {
            print(error)
        }
    }
}
