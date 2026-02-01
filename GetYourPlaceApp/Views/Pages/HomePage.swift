import SwiftUI

struct HomePage: View {
    @StateObject var viewModel: HomePageViewModel
    @State var selectedTab: String
    @Environment(AuthManager.self) private var auth

    init(viewModel: HomePageViewModel = HomePageViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.selectedTab = "home"
    }

    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.1, blue: 0.1)
                .ignoresSafeArea()
            
            if(selectedTab == "home"){
                SearchResidenceView(viewModel:viewModel);
            }
            else if(selectedTab == "rents"){
                AuthGate {
                    MyRents()
                }
            }
            else if(selectedTab == "heart"){
                AuthGate {
                    InterestsView()
                }
            }
            else if(selectedTab == "macths"){
                AuthGate {
                    MatchsView()
                }
            }
            else if(selectedTab == "profile"){
                AuthGate {
                    ProfileMainView(profile: viewModel.profile)
                }
            }

            VStack {
                Spacer()
                HStack(spacing: 0) {
                    MenuItem(icon: "house.fill", label: "Home", isSelected: selectedTab == "home") { selectedTab = "home" }
                    MenuItem(icon: "key.fill", label: "My Rents", isSelected: selectedTab == "rents") { selectedTab = "rents" }
                    MenuItem(icon: "heart.fill", label: "Interests", isSelected: selectedTab == "heart") { selectedTab = "heart" }
                    MenuItem(icon: "bubble.left.fill", label: "Matchs", isSelected: selectedTab == "macths") { selectedTab = "macths" }
                    MenuItem(icon: "person.circle.fill", label: "Profile", isSelected: selectedTab == "profile") { selectedTab = "profile" }
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 16)
                .cornerRadius(128)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomePage().environment(AuthManager())
}
