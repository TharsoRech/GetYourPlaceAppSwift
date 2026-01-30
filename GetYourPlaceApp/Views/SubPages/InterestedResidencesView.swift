import SwiftUI

struct InterestedResidencesView: View {
    @StateObject var viewModel: InterestedResidencesViewModel
    @State private var selectedResidence: Residence? = nil
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(red: 0.1, green: 0.1, blue: 0.1)
                .ignoresSafeArea()
            
            VStack {
                Text("Interested Places")
                    .foregroundColor(.white)
                    .font(.system(size: 22, weight: .regular))
                    .padding(.top, 10)
                
                ResidenceListView(
                    residences: $viewModel.interestedResidences,
                    isLoading: viewModel.isLoading,
                    isFetchingMore: viewModel.isFetchingMore,
                    onLoadMore: {
                    },
                    onSelect: { residence in
                        selectedResidence = residence
                    }
                )
                .padding(16)
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
                .zIndex(100)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    InterestedResidencesView(viewModel: InterestedResidencesViewModel())
        .environment(AuthManager.mock(role: .renter))
}
