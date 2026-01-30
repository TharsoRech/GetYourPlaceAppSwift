import SwiftUI

struct MatchsView: View {
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
                Text("Matchs").tag(0)
                Text("Chat").tag(1)
            }
            .pickerStyle(.segmented)
            .padding()
            .background(Color(red: 0.1, green: 0.1, blue: 0.1))
            
            TabView(selection: $selectedTab) {
                MatchsResidencesView()
                    .tag(0)
                
                ConversationsListView()
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .background(Color(red: 0.1, green: 0.1, blue: 0.1).ignoresSafeArea())
    }
}

#Preview {
    MatchsView().environment(AuthManager.mock(role: .renter))
}
