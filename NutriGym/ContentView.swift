//
//  ContentView.swift
//  NutriGym
//
//  Created by Evan Bond on 2023-10-18.
//

import SwiftUI

// Model
struct Client: Identifiable {
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
    @ObservedObject var viewModel: ClientsViewModel
    @State private var selectedClient: Client?

    var body: some View {
        NavigationView {
            List(viewModel.clients, id: \.id) { client in
                Button(action: {
                    selectedClient = client
                }) {
                    Text(client.name)
                }
            }
            .sheet(item: $selectedClient) { client in
                NavigationView {
                    ClientDetailView(client: client)
                }
            }
            .navigationBarTitle("Clients")
        }
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
}

struct ClientDetailView: View {
    let client: Client

    var body: some View {
        VStack {
            Text("Name: \(client.name)")
            // Add more client information here (e.g., age, height, weight)
        }
        .navigationBarTitle(client.name)
    }
}

#Preview {
    ContentView()
}
