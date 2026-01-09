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
                    onFilterTap: { viewModel.FilterClicked() }
                )
                .padding(.horizontal, 16)
                
                // 3. Filters - Added horizontal padding
                VStack(alignment: .leading) {
                    ClickFilterList(filters: viewModel.filters) { selectedFilter in
                        viewModel.ApplyDefaultFilter(filter: selectedFilter)
                    }
                }.padding(.horizontal, 8)

                // 4. Residence List
                VStack(alignment: .leading) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 16) {
                            ForEach(viewModel.residences) { residence in
                                ResidenceView(residence: residence)
                            }
                        }
                        .padding(.vertical, 8) // Standardized vertical padding
                    }
                }
                .padding(.horizontal, 16)

                Spacer()
                
                .sheet(isPresented: $viewModel.showingFilters) {
                        FilterView(filter: $viewModel.currentFilter)
                            .presentationDetents([.medium, .large])
                            .presentationDragIndicator(.visible)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    HomePage()
}
