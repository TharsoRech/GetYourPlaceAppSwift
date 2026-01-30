import SwiftUI

struct FavoriteResidences: View {
    @StateObject var viewModel: FavoriteResidencesViewModel
    @State private var selectedResidence: Residence? = nil
    
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
                    onLoadMore: { },
                    onSelect: { residence in
                                            selectedResidence = residence
                                        }
                ).padding(16)
            }
            
            if let residence = selectedResidence {
                            ResidenceDetailPopup(
                                residence: residence,
                                isPresented: Binding(
                                    get: { selectedResidence != nil },
                                    set: { if !$0 { selectedResidence = nil } }
                                )
                            )
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .scale(scale: 0.9)),
                                removal: .opacity.combined(with: .scale(scale: 1.1))
                            ))
                            .zIndex(100) // Ensure it's above everything else
                        }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
}

// Ensure you have a mock for the preview to work
#Preview {
    FavoriteResidences().environment(AuthManager.mock(role: .renter))
}
