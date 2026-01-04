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
            VStack {
                HStack {
                    Text("Explore")
                        .foregroundColor(.white)
                        .font(.system(size: 22, weight: .regular, design: .default))
                    Spacer()
                    NotificationButton(count: 2)
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                CustomSearchBar(text: $viewModel.searchText, onSearchTap: {viewModel.PerformSearch()},
                        onFilterTap:{viewModel.FilterClicked()})
                .padding(.top, 8)
                VStack(alignment: .leading){
             
                }
                    .padding(.top, 8)

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomePage()
}
