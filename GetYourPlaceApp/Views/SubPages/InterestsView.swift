import SwiftUI

struct InterestsView: View {
    @State private var selectedTab = 0
    @StateObject var favoritesVM = FavoriteResidencesViewModel()
    @StateObject var interestedVM = InterestedResidencesViewModel()
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .white
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $selectedTab) {
                Text("Interested").tag(0)
                Text("Favorites").tag(1)
            }
            .pickerStyle(.segmented)
            .padding()
            .background(Color(red: 0.1, green: 0.1, blue: 0.1))
            
            // 2. The Content Area
            TabView(selection: $selectedTab) {
                InterestedResidencesView(viewModel: interestedVM)
                    .tag(0)
                
                FavoriteResidences(viewModel: favoritesVM)
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never)) // Allows swiping without bottom dots
        }
        .background(Color(red: 0.1, green: 0.1, blue: 0.1).ignoresSafeArea())
    }
}

#Preview {
    InterestsView().environment(AuthManager.mock(role: .renter))
}
