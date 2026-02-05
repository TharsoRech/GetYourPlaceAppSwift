import SwiftUI

struct FavoriteResidences: View {
    @StateObject var viewModel: FavoriteResidencesViewModel
    var onSelect: (Residence) -> Void // Callback to parent
    
    var body: some View {
        VStack {
            Text("Favorite Places")
                .foregroundColor(.white)
                .font(.system(size: 22, weight: .regular))
                .padding(.top, 10)
            
            ResidenceListView(
                residences: $viewModel.favoritesResidences,
                isLoading: viewModel.isLoading,
                isFetchingMore: viewModel.isFetchingMore,
                onLoadMore: { },
                onSelect: onSelect // Send selection up
            )
            .padding(16)
        }
        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
    }
}

#Preview {
    FavoriteResidences(
        viewModel: FavoriteResidencesViewModel(),
        onSelect: { residence in
            print("Selected: \(residence.name)")
        }
    )
    .environment(AuthManager.mock(role: .renter))
}
