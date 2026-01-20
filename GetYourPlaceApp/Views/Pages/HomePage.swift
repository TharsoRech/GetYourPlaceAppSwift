import SwiftUI

struct HomePage: View {
    @StateObject var viewModel: HomePageViewModel

    init(viewModel: HomePageViewModel = HomePageViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.1, blue: 0.1)
                .ignoresSafeArea()
            
            if(viewModel.selectedTab == "home"){
                SearchResidenceView(viewModel:viewModel);
            }
            else if(viewModel.selectedTab == "rents"){
                MyRents()
            }

            // 5. CUSTOM FLOATING BOTTOM BAR
            VStack {
                Spacer()
                HStack(spacing: 0) {
                    MenuItem(icon: "house.fill", label: "Home", isSelected: viewModel.selectedTab == "home") { viewModel.selectedTab = "home" }
                    MenuItem(icon: "key.fill", label: "My Rents", isSelected: viewModel.selectedTab == "rents") { viewModel.selectedTab = "rents" }
                    MenuItem(icon: "heart.fill", label: "Saved", isSelected: viewModel.selectedTab == "heart") { viewModel.selectedTab = "heart" }
                    MenuItem(icon: "bubble.left.fill", label: "Chat", isSelected: viewModel.selectedTab == "chat") { viewModel.selectedTab = "chat" }
                    MenuItem(icon: "person.circle.fill", label: "Profile", isSelected: viewModel.selectedTab == "profile") { viewModel.selectedTab = "profile" }
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 16)
                .cornerRadius(128)
                .padding(.bottom, 10)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomePage()
}
