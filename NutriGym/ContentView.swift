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

// Model
struct NutritionalPlan: Identifiable {
    var id: UUID
    var name: String
    var description: String
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

// View Model
class NutritionalPlansViewModel: ObservableObject {
    @Published var nutritionalPlans: [NutritionalPlan]

    init() {
        // Initialize or fetch nutritional plan data here
        self.nutritionalPlans = [
            NutritionalPlan(id: UUID(), name: "Plan 1", description: "Description for Plan 1"),
            NutritionalPlan(id: UUID(), name: "Plan 2", description: "Description for Plan 2")
            // Add more nutritional plans as needed
        ]
    }
}

struct NutritionalPlansView: View {
    @ObservedObject var viewModel: NutritionalPlansViewModel

    var body: some View {
        List(viewModel.nutritionalPlans, id: \.id) { plan in
            NavigationLink(destination: NutritionalPlanDetailView(plan: plan)) {
                Text(plan.name)
            }
        }
        .navigationBarTitle("Nutritional Plans")
    }
}

struct NutritionalPlanDetailView: View {
    let plan: NutritionalPlan

    var body: some View {
        VStack {
            Text("Name: \(plan.name)")
            Text("Description: \(plan.description)")
            // Add more details about the nutritional plan
        }
        .navigationBarTitle(plan.name)
    }
}

// View
struct DashboardView: View {
    var body: some View {
        Text("Dashboard")
    }
}
// View
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
// View
struct SettingsView: View {
    var body: some View {
        Text("Settings")
    }
}

struct ContentView: View {
    @StateObject var clientsViewModel = ClientsViewModel()
    @StateObject var nutritionalPlansViewModel = NutritionalPlansViewModel()
    @State private var showingNutritionalPlans = false

    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    HStack {
                        NavigationLink(destination: DashboardView()) {
                            Text("Dashboard")
                                .padding(20)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        NavigationLink(destination: ClientsView(viewModel: clientsViewModel)) {
                            Text("Clients")
                                .padding(20)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        NavigationLink(destination: SettingsView()) {
                            Text("Settings")
                                .padding(20)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    Spacer()
                    NavigationLink(
                        destination: NutritionalPlansView(viewModel: nutritionalPlansViewModel),
                        isActive: $showingNutritionalPlans,
                        label: {
                            Button(action: {
                                showingNutritionalPlans = true
                            }) {
                                Text("Nutritional Plans")
                                    .padding(20)
                                    .background(Color.orange)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    )
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

//            NutritionalPlansView(viewModel: nutritionalPlansViewModel)
//                .tabItem {
//                    Image(systemName: "doc.text")
//                    Text("Nutritional Plans")
//                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            
        }
    }
}


struct ClientDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let client: Client

    var body: some View {
        VStack {
            Text("Name: \(client.name)")
            // Add more client information here (e.g., age, height, weight)
        }
        .navigationBarTitle(client.name)
        .navigationBarItems(trailing: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Close")
                .padding(10)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
        })
    }
}

#Preview {
    ContentView()
}
