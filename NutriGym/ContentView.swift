//
//  ContentView.swift
//  NutriGym
//
//  Created by Evan Bond on 2023-10-18.
//

import SwiftUI

//
enum Gender: String, CaseIterable {
    case male = "Male"
    case female = "Female"
}

// Model
struct Client: Identifiable {
    var id: UUID
    var name: String
    var height: Double
    var weight: Double
    var age: Int
    var gender: Gender
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
            Client(id: UUID(), name: "Evan Bond", height: 175.0, weight: 70.0, age: 30, gender: .male),
            Client(id: UUID(), name: "David Rallo", height: 165.0, weight: 60.0, age: 28, gender: .male),
            Client(id: UUID(), name: "Alice Smith", height: 160.0, weight: 55.0, age: 25, gender: .female),
            Client(id: UUID(), name: "Sarah Johnson", height: 170.0, weight: 68.0, age: 32, gender: .female),
            Client(id: UUID(), name: "John Doe", height: 180.0, weight: 75.0, age: 35, gender: .male)
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
    @State private var isAddingClient = false
    @State private var newClientName = ""
    @State private var newClientHeight = 0.0
    @State private var newClientWeight = 0.0
    @State private var newClientAge = 0
    @State private var newClientGender = Gender.male // Default to Male

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.clients) { client in
                    Button(action: {
                        selectedClient = client
                    }) {
                        Text(client.name)
                    }
                }
            }
            .navigationBarTitle("Clients")
            .navigationBarItems(trailing:
                Button(action: {
                    isAddingClient = true
                }) {
                    Text("New Client")
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            )
        }
        .sheet(isPresented: $isAddingClient) {
            // New Client Form
            VStack {
                Text("New Client Form")
                    .font(.title)
                    .padding()
                
                TextField("Enter Client Name", text: $newClientName)
                    .padding()
                
                TextField("Enter Height", value: $newClientHeight, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .padding()
                
                TextField("Enter Weight", value: $newClientWeight, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .padding()
                
                TextField("Enter Age", value: $newClientAge, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .padding()
                
                Picker("Select Gender", selection: $newClientGender) {
                    ForEach(Gender.allCases, id: \.self) { gender in
                        Text(gender.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Button("Add Client", action: {
                    // Generate a new ID for the client
                    let newClientID = UUID()
                    
                    // Create a new client with the entered information
                    let newClient = Client(
                        id: newClientID,
                        name: newClientName,
                        height: newClientHeight,
                        weight: newClientWeight,
                        age: newClientAge,
                        gender: newClientGender
                    )
                    
                    // Add the new client to the view model
                    viewModel.clients.append(newClient)
                    
                    // Close the sheet
                    isAddingClient = false
                })
                .padding(10)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .sheet(item: $selectedClient) { client in
            NavigationView {
                ClientDetailView(client: client)
            }
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
    
    // Create a NumberFormatter for formatting height and weight
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2 // Set to 2 decimal places
        return formatter
    }()

    var body: some View {
        VStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .padding(.top, 20)
            
            Text(client.name)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 10)
            
            HStack {
                Text("Age: \(client.age)")
                Spacer()
                Text("Gender: \(client.gender.rawValue)")
            }
            .font(.subheadline)
            .foregroundColor(.gray)
            .padding(.top, 5)
            
            Divider()
                .padding([.top, .bottom], 10)
            
            HStack {
                Text("Height: \(numberFormatter.string(from: NSNumber(value: client.height) ) ?? "") cm")
                Spacer()
                Text("Weight: \(numberFormatter.string(from: NSNumber(value: client.weight)) ?? "") kg")
            }
            .font(.headline)
            .foregroundColor(.black)
            
            Spacer()
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
