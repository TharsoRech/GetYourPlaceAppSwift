import SwiftUI

struct SearchResidenceView: View {
    @StateObject var viewModel: HomePageViewModel
    @Environment(AuthManager.self) private var auth
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack (spacing: 16) {
                HStack {
                    Text("Explore")
                        .foregroundColor(.white)
                        .font(.system(size: 22, weight: .regular))
                    Spacer()
                    
                    Color.clear.frame(width: 45, height: 45)
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
                
                // 3. Filters
                VStack(alignment: .leading) {
                    ClickFilterList(filters: viewModel.filters) { selectedFilter in
                        viewModel.ApplyDefaultFilter(filter: selectedFilter)
                    }
                }.padding(.horizontal, 8)

                // 4. Residence List
                ResidenceListView(
                    residences: $viewModel.residences,
                    isLoading: viewModel.isLoading,
                    isFetchingMore: viewModel.isFetchingMore,
                    onLoadMore: { viewModel.loadNextPage() }
                ).padding(16)
            }
            
            if auth.isAuthenticated {
                NotificationButton(notifications: $viewModel.newNotifications)
                    .padding(.trailing, 32)
                    .padding(.top, 10)
                    .zIndex(1)
                    .transition(.scale.combined(with: .opacity)) // Nice pop-in effect
            }
      
        }
        .sheet(isPresented: $viewModel.showingFilters) {
            FilterView(filter: $viewModel.currentFilter) { isApplied in
                viewModel.ApplyCustomFilters(isApplied: isApplied)
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    SearchResidenceView(viewModel:HomePageViewModel()).environment(AuthManager())
}

