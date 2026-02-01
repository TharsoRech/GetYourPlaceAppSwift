import SwiftUI

struct MatchsView: View {
    @State private var selectedTab = 0
    @State private var navigationPath = NavigationPath()
    @Environment(AuthManager.self) var authManager
    
    init() {
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.lightGray], for: .normal)
        
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        
        UISegmentedControl.appearance().backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        
        UISegmentedControl.appearance().selectedSegmentTintColor = .white
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
            
            if selectedTab == 0 {
                MatchsResidencesView(selectedTab: $selectedTab, navigationPath: $navigationPath)
            } else {
                ConversationsListView(navigationPath: $navigationPath)
            }
            
            Spacer(minLength: 0)
        }
        .background(Color(red: 0.1, green: 0.1, blue: 0.1).ignoresSafeArea())
    }
}

#Preview("Owner View") {
    MatchsView()
        .environment(AuthManager.mock(role: .owner))
}

#Preview("Renter View") {
    MatchsView()
        .environment(AuthManager.mock(role: .renter))
}
