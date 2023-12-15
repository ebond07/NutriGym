//
//  ContentView.swift
//  NutriGym
//
//  Created by Evan Bond on 2023-10-18.
//

import SwiftUI

extension UIColor {
    func toColor() -> Color {
        return Color(self)
    }
}

// Example of converting a UIColor to Color
let uiColor = UIColor(red: 139/255, green: 69/255, blue: 19/255, alpha: 1.0) // Warm Brown
let swiftUIColor = uiColor.toColor()
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
    var caloriesPerDay: Int
    var proteinIntake: Double
    var carbohydrateIntake: Double
    var fatIntake: Double
}

// Model for User Settings
class UserSettings: ObservableObject {
    @Published var name: String = "John Doe"
    @Published var email: String = "johndoe@example.com"
    @Published var pushNotificationsEnabled: Bool = true
    @Published var darkModeEnabled: Bool = false
}

let userSettings = UserSettings()

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
    
    func removeClient(_ client: Client) {
            if let index = clients.enumerated().first(where: { $0.element.id == client.id })?.offset {
                clients.remove(at: index)
            }
        }
}


// View Model
class NutritionalPlansViewModel: ObservableObject {
    @Published var nutritionalPlans: [NutritionalPlan]

    init() {
        // Initialize or fetch nutritional plan data here
        self.nutritionalPlans = [
            NutritionalPlan(id: UUID(), name: "Plan 1", description: "Description for Plan 1", caloriesPerDay: 2000, proteinIntake: 150.0, carbohydrateIntake: 250.0, fatIntake: 50.0),
            NutritionalPlan(id: UUID(), name: "Plan 2", description: "Description for Plan 2", caloriesPerDay: 1800, proteinIntake: 120.0, carbohydrateIntake: 210.0, fatIntake: 45.0),
            NutritionalPlan(id: UUID(), name: "Plan 3", description: "Description for Plan 3", caloriesPerDay: 2200, proteinIntake: 160.0, carbohydrateIntake: 270.0, fatIntake: 55.0),
            NutritionalPlan(id: UUID(), name: "Plan 4", description: "Description for Plan 4", caloriesPerDay: 1900, proteinIntake: 130.0, carbohydrateIntake: 220.0, fatIntake: 48.0),
            NutritionalPlan(id: UUID(), name: "Plan 5", description: "Description for Plan 5", caloriesPerDay: 2100, proteinIntake: 140.0, carbohydrateIntake: 240.0, fatIntake: 52.0)
            // Add more nutritional plans as needed
        ]
    }
    func removePlan(_ nutritionalPlan: NutritionalPlan) {
        if let index = nutritionalPlans.enumerated().first(where: {
            $0.element.id == nutritionalPlan.id })?.offset {
            nutritionalPlans.remove(at: index)
        }
    }
}


struct NutritionalPlansView: View {
    @ObservedObject var viewModel: NutritionalPlansViewModel
    @State private var isAddingPlan = false
    @State private var newPlanName = ""
    @State private var newPlanDescription = ""
    @State private var newPlanCalories = ""
    @State private var newPlanProtein = ""
    @State private var newPlanCarbohydrates = ""
    @State private var newPlanFat = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.nutritionalPlans) { plan in
                    HStack {
                        NavigationLink(destination: NutritionalPlanDetailView(plan: plan)) {
                            Text(plan.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        Spacer()
                        Button(action: {
                            // Handle delete action here
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                                .onTapGesture {
                                    viewModel.removePlan(plan)
                                }
                        }
                    }
                }
            }
            .navigationBarTitle("Nutritional Plans")

            .navigationBarItems(trailing:
                Button(action: {
                    isAddingPlan = true
                }) {
                    Image(systemName: "plus")
                        .padding(10)
                }
            )
            .sheet(isPresented: $isAddingPlan) {
                VStack {
                    Text("New Nutritional Plan Form")
                        .font(.title)
                        .padding()

                    TextField("Enter Plan Name", text: $newPlanName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    TextField("Enter Description", text: $newPlanDescription)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    TextField("Calories per Day", text: $newPlanCalories)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    TextField("Protein Intake (g)", text: $newPlanProtein)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    TextField("Carbohydrate Intake (g)", text: $newPlanCarbohydrates)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    TextField("Fat Intake (g)", text: $newPlanFat)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    HStack {
                        Button("Cancel", action: {
                            isAddingPlan = false
                        })
                        .buttonStyle(DefaultButtonStyle())
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)

                        Button("Add Plan", action: {
                            let newPlanID = UUID()

                            let newPlan = NutritionalPlan(
                                id: newPlanID,
                                name: newPlanName,
                                description: newPlanDescription,
                                caloriesPerDay: Int(newPlanCalories) ?? 0,
                                proteinIntake: Double(newPlanProtein) ?? 0.0,
                                carbohydrateIntake: Double(newPlanCarbohydrates) ?? 0.0,
                                fatIntake: Double(newPlanFat) ?? 0.0
                            )

                            viewModel.nutritionalPlans.append(newPlan)
                            isAddingPlan = false
                        })
                        .buttonStyle(DefaultButtonStyle())
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                }
            }
        }
    }
}


struct NutritionalPlanDetailView: View {
    let plan: NutritionalPlan

    var body: some View {
        VStack {
            VStack {
                Text(plan.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .foregroundColor(.black) // Change the text color

                Text("Description: \(plan.description)")
                    .font(.subheadline)
                    .foregroundColor(.black) // Change the text color
                    .padding(.top, 5)
            }
            .padding(.top, 10)

            Divider()
                .padding([.top, .bottom], 10)

            VStack(alignment: .leading) {
                Text("Calories per Day")
                    .font(.headline)
                    .foregroundColor(.black) // Change the text color

                Text("\(plan.caloriesPerDay) kcal")
                    .font(.subheadline)
                    .foregroundColor(.black) // Change the text color
            }

            Spacer()

            VStack(alignment: .leading) {
                Text("Protein Intake")
                    .font(.headline)
                    .foregroundColor(.black) // Change the text color

                Text("\(plan.proteinIntake) grams")
                    .font(.subheadline)
                    .foregroundColor(.black) // Change the text color
            }

            Spacer()

            VStack(alignment: .leading) {
                Text("Carbohydrate Intake")
                    .font(.headline)
                    .foregroundColor(.black) // Change the text color

                Text("\(plan.carbohydrateIntake) grams")
                    .font(.subheadline)
                    .foregroundColor(.black) // Change the text color
            }

            Spacer()

            VStack(alignment: .leading) {
                Text("Fat Intake")
                    .font(.headline)
                    .foregroundColor(.black) // Change the text color

                Text("\(plan.fatIntake) grams")
                    .font(.subheadline)
                    .foregroundColor(.black) // Change the text color
            }

            Spacer()
            Button(action: {
                // Handle delete action here
            
            }) {
                Image(systemName: "trash.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .background(
            Image("proteinshake")
                .resizable()
                .scaledToFill()
                .opacity(0.5)
                .edgesIgnoringSafeArea(.all)
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true) // Hide the back button
        .padding(.horizontal, 20)
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
    @State private var newClientHeight = ""
    @State private var newClientWeight = ""
    @State private var newClientAge = ""
    @State private var newClientGender = Gender.male // Default to Male

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.clients) { client in
                    HStack {
                        Button(action: {
                            selectedClient = client
                        }) {
                            Text(client.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        Spacer()
                        Button(action: {
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                                .onTapGesture {
                                    viewModel.removeClient(client)
                                }
                        }
                    }
                }
            }
            .navigationBarTitle("Clients")

            .navigationBarItems(trailing:
                Button(action: {
                    isAddingClient = true
                }) {
                    Image(systemName: "plus")
                        .padding(10)
                }
            )
            .sheet(isPresented: $isAddingClient) {
                VStack {
                    Text("New Client Form")
                        .font(.title)
                        .padding()

                    TextField("Enter Client Name", text: $newClientName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    TextField("Enter Height", text: $newClientHeight)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    TextField("Enter Weight", text: $newClientWeight)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    TextField("Enter Age", text: $newClientAge)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Picker("Select Gender", selection: $newClientGender) {
                        ForEach(Gender.allCases, id: \.self) { gender in
                            Text(gender.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()

                    HStack {
                        Button("Cancel", action: {
                            isAddingClient = false
                        })
                        .buttonStyle(DefaultButtonStyle())
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)

                        Button("Add Client", action: {
                            let newClientID = UUID()

                            let height = Double(newClientHeight) ?? 0.0
                            let weight = Double(newClientWeight) ?? 0.0
                            let age = Int(newClientAge) ?? 0

                            let newClient = Client(
                                id: newClientID,
                                name: newClientName,
                                height: height,
                                weight: weight,
                                age: age,
                                gender: newClientGender
                            )

                            viewModel.clients.append(newClient)
                            isAddingClient = false
                        })
                        .buttonStyle(DefaultButtonStyle())
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                }
            }

            .sheet(item: $selectedClient) { client in
                NavigationView {
                    ClientDetailView(client: client)
                }
            }
        }
    }
}



// View
struct SettingsView: View {
    struct MockUserData {
        var pushNotificationsEnabled: Bool
        var darkModeEnabled: Bool
    }

    // Create mock user data
    @State private var mockUserData = MockUserData(pushNotificationsEnabled: true, darkModeEnabled: false)

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile Settings")) {
                    NavigationLink(destination: ProfileSettingsView()) {
                        Text("Edit Profile")
                    }
                }
                
                Section(header: Text("App Settings")) {
                    Toggle("Push Notifications", isOn: $mockUserData.pushNotificationsEnabled)
                    Toggle("Dark Mode", isOn: $mockUserData.darkModeEnabled)
                }
                
                Section(header: Text("Account Settings")) {
                    Button(action: {
                        // Handle account related actions
                    }) {
                        Text("Sign Out")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("Settings")
        }
    }
}

// View
struct ProfileSettingsView: View {
    @State private var newName = userSettings.name
    @State private var newEmail = userSettings.email

    var body: some View {
        Form {
            Section(header: Text("Profile Information")) {
                TextField("Name", text: $newName)
                TextField("Email", text: $newEmail)
            }
            
            Section {
                Button(action: {
                    userSettings.name = newName
                    userSettings.email = newEmail
                    // Save changes and update user settings
                }) {
                    Text("Save Changes")
                }
            }
        }
        .navigationBarTitle("Edit Profile")
    }
}


struct ContentView: View {
    let warmBrownUIColor = UIColor(red: 139/255, green: 69/255, blue: 19/255, alpha: 1.0)
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
                                .background(warmBrownUIColor.toColor())
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        NavigationLink(destination: ClientsView(viewModel: clientsViewModel)) {
                            Text("Clients")
                                .padding(20)
                                .background(warmBrownUIColor.toColor())
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        NavigationLink(destination: SettingsView()) {
                            Text("Settings")
                                .padding(20)
                                .background(warmBrownUIColor.toColor())
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
                                    .background(warmBrownUIColor.toColor())
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    )
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
        .background(
            Image("testback")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
    }
}


struct ClientDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: ClientsViewModel
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
            .font(.headline)
            .foregroundColor(.black)
            .padding(.horizontal, 20)
            
            Divider()
                .padding([.top, .bottom], 10)
            
            HStack {
                Text("Height: \(numberFormatter.string(from: NSNumber(value: client.height) ) ?? "") cm")
                Spacer()
                Text("Weight: \(numberFormatter.string(from: NSNumber(value: client.weight)) ?? "") kg")
            }
            .font(.headline)
            .foregroundColor(.black)
            .padding(.horizontal, 20)
            
            Spacer()
            
            HStack {
                Spacer()
                Button(action: {
                    viewModel.removeClient(client)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "trash.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.red)
                }
                .padding()
                Spacer()
            }
        }
        .navigationBarTitle("Client Details")
        .navigationBarItems(trailing:
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Close")
                    .padding(10)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        )
        .modifier(BackgroundImageModifier(imageName: "dumbbell", opacity: 0.5)
        )
    }
}

struct BackgroundImageModifier: ViewModifier {
    var imageName: String
    var opacity: Double
    
    func body(content: Content) -> some View {
        content
            .background(
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .opacity(opacity)
                    .edgesIgnoringSafeArea(.all) // Ignore safe area insets
            )
    }
}


#Preview {
    ContentView()
}
