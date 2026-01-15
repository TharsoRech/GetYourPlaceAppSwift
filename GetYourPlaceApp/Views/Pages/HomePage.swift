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
            
            VStack (spacing: 16) {
                // 1. Header
                HStack {
                    Text("Explore")
                        .foregroundColor(.white)
                        .font(.system(size: 22, weight: .regular, design: .default))
                    Spacer()
                    NotificationButton(count: 2)
                }
                .padding(.horizontal, 32)
                .padding(.top, 10)
                
                // 2. Search Bar
                CustomSearchBar(
                    text: $viewModel.searchText,
                    onSearchTap: { viewModel.PerformSearch() },
                    onFilterTap: { viewModel.FilterClicked() },
                    isFilterActive: $viewModel.isFilterActive
                )
                .padding(.horizontal, 16)
                
                // 3. Filters
                VStack(alignment: .leading) {
                    ClickFilterList(filters: viewModel.filters) { selectedFilter in
                        viewModel.ApplyDefaultFilter(filter: selectedFilter)
                    }
                }.padding(.horizontal, 8)

                // 4. Residence List with Skeleton Logic
                ResidenceListView(viewModel: viewModel)
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
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $viewModel.showingFilters) {
            FilterView(filter: $viewModel.currentFilter, applyChanges: { viewModel.ApplyCustomFilters() })
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    HomePage()
}
