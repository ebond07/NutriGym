//
//  ContentView.swift
//  NutriGym
//
//  Created by Evan Bond on 2023-10-18.
//

import SwiftUI

// Model
struct Client {
    var id: UUID
    var name: String
}

// View Model
class ClientsViewModel: ObservableObject {
    @Published var clients: [Client]

    init() {
        // Initialize or fetch client data here
        self.clients = [
            Client(id: UUID(), name: "Evan Bond"),
            Client(id: UUID(), name: "David Rallo")
            // Add more clients as needed
        ]
    }
}

struct DashboardView: View {
    var body: some View {
        Text("Dashboard")
    }
}

struct ClientsView: View {
    var body: some View {
        Text("Clients")
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings")
    }
}

struct ContentView: View {
    @StateObject var clientsViewModel = ClientsViewModel()

    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    HStack {
                        NavigationLink(destination: DashboardView()) {
                            Text("Dashboard")
                                .padding(20)
                        }
                        NavigationLink(destination: ClientsView(viewModel: clientsViewModel)) {
                                                    Text("Clients")
                                                        .padding(20)
                        }
                        NavigationLink(destination: SettingsView()) {
                            Text("Settings")
                                .padding(20)
                        }
                    }
                    Spacer()
                }
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(leading: Text("NutriGym")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center))
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            ClientsView(viewModel: clientsViewModel)
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Clients")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
    struct ClientsView: View {
        @ObservedObject var viewModel: ClientsViewModel

        var body: some View {
            List(viewModel.clients, id: \.id) { client in
                Text(client.name)
            }
        }
    }
}

#Preview {
    ContentView()
}
