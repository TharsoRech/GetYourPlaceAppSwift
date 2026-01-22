import SwiftUI

struct SearchResidenceView: View {
    @StateObject var viewModel: HomePageViewModel
    
    var body: some View {
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
            
            // 3. Filters
            VStack(alignment: .leading) {
                ClickFilterList(filters: viewModel.filters) { selectedFilter in
                    viewModel.ApplyDefaultFilter(filter: selectedFilter)
                }
            }.padding(.horizontal, 8)

            // 4. Residence List with Skeleton Logic
            ResidenceListView(
                residences: viewModel.residences,
                isLoading: viewModel.isLoading,
                isFetchingMore: viewModel.isFetchingMore,
                onLoadMore: { viewModel.loadNextPage() }
            )
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
    SearchResidenceView(viewModel:HomePageViewModel())
}
