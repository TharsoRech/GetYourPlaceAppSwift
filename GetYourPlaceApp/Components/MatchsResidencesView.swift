import SwiftUI

struct MatchsResidencesView: View {
    @StateObject private var viewModel: MatchsResidencesViewModel
    @Binding var selectedTab: Int
    @Binding var activeConversation: Conversation?
    @Environment(AuthManager.self) var authManager
    
    init(selectedTab: Binding<Int>,
             activeConversation: Binding<Conversation?>,
             viewModel: @autoclosure @escaping () -> MatchsResidencesViewModel = MatchsResidencesViewModel()) {
            self._selectedTab = selectedTab
            self._activeConversation = activeConversation
            self._viewModel = StateObject(wrappedValue: viewModel())
        }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                MatchsResidencesSkeleton()
                    .transition(.opacity)
            } else {
                TabView {
                    if authManager.currentUser?.role == .owner {
                        DiscoveryView(profiles: $viewModel.profiles)
                            .tabItem {
                                Label("Pending", systemImage: "square.stack.3d.up.fill")
                            }
                    }
                    else{
                        
                        HistoryListView(profiles: $viewModel.profiles, filter: .pending) { _ in }
                        .tabItem {
                            Label("Pending", systemImage: "square.stack.3d.up.fill")
                        }
                    }

                    
                    HistoryListView(profiles: $viewModel.profiles, filter: .accepted) { profile in
                        Task {
                            let conversation = await viewModel.getConversation(profile: profile)
                            
                            await MainActor.run {
                                self.activeConversation = conversation
                                
                                self.selectedTab = 1
                             }
                        }
                    }
                    .tabItem {
                        Label("Accepted", systemImage: "checkmark.circle.fill")
                    }
                    
                    HistoryListView(profiles: $viewModel.profiles, filter: .rejected) { _ in }
                    .tabItem {
                        Label("Rejected", systemImage: "xmark.circle.fill")
                    }
                }
                .accentColor(.white)
                .transition(.opacity)
            }
        }
        .animation(.default, value: viewModel.isLoading)
        .preferredColorScheme(.dark)
        .toolbar(.hidden, for: .navigationBar)
        .padding(.bottom, 100)
    }
}

#Preview("Owner View") {
    MatchsResidencesView(
        selectedTab: .constant(0),
        activeConversation: .constant(Conversation.mock)
    )
        .environment(AuthManager.mock(role: .owner))
}

#Preview("Renter View") {
    MatchsResidencesView(
        selectedTab: .constant(0),
        activeConversation: .constant(Conversation.mock)
    )
        .environment(AuthManager.mock(role: .renter))
}
