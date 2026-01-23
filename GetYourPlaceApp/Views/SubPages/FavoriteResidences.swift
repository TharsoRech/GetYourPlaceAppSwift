import SwiftUI

struct FavoriteResidences: View {
    @StateObject var viewModel: FavoriteResidencesViewModel
    
    init(viewModel: FavoriteResidencesViewModel = FavoriteResidencesViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(red: 0.1, green: 0.1, blue: 0.1)
                .ignoresSafeArea()
            VStack {
                Text("Favorite Places")
                    .foregroundColor(.white)
                    .font(.system(size: 22, weight: .regular, design: .default))
                Spacer()
                ResidenceListView(
                    residences: $viewModel.favoritesResidences,
                    isLoading: viewModel.isLoading,
                    isFetchingMore: viewModel.isFetchingMore,
                    onLoadMore: { }
                ).padding(16)
            }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
}

// Ensure you have a mock for the preview to work
#Preview {
    FavoriteResidences()
}
