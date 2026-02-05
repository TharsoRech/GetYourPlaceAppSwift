import SwiftUI

struct InterestsView: View {
    @State private var selectedTab = 0
    @StateObject var favoritesVM = FavoriteResidencesViewModel()
    @StateObject var interestedVM = InterestedResidencesViewModel()
    
    // Move the selection state here for full-screen coverage
    @State private var selectedResidence: Residence? = nil
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .white
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.1, blue: 0.1).ignoresSafeArea()
            
            VStack(spacing: 0) {
                Picker("", selection: $selectedTab) {
                    Text("Interested").tag(0)
                    Text("Favorites").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()
                .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                
                TabView(selection: $selectedTab) {
                    // Pass the selection logic up to this parent
                    InterestedResidencesView(viewModel: interestedVM) { res in
                        selectedResidence = res
                    }
                    .tag(0)
                    
                    FavoriteResidences(viewModel: favoritesVM) { res in
                        selectedResidence = res
                    }
                    .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            
            // FULL SCREEN POPUP
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
    }
}

#Preview {
    InterestsView().environment(AuthManager.mock(role: .renter))
}
