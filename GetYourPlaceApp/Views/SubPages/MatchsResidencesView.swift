import SwiftUI

struct MatchsResidencesView: View {
    @StateObject private var viewModel: MatchsResidencesViewModel
    @Binding var selectedTab: Int
    @Binding var navigationPath: NavigationPath
    
    init(selectedTab: Binding<Int>,
         navigationPath: Binding<NavigationPath>,
         viewModel: @autoclosure @escaping () -> MatchsResidencesViewModel = MatchsResidencesViewModel()) {
        self._selectedTab = selectedTab
        self._navigationPath = navigationPath
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                MatchsResidencesSkeleton()
                    .transition(.opacity)
            } else {
                TabView {
                    DiscoveryView(profiles: $viewModel.profiles)
                        .tabItem {
                            Label("Pending", systemImage: "square.stack.3d.up.fill")
                        }
                    
                    HistoryListView(profiles: $viewModel.profiles, filter: .accepted) { profile in
                        Task {
                            let conversation = await viewModel.getConversation(profile: profile)
                            
                            // UI updates must happen on the Main Thread
                            await MainActor.run {
                                selectedTab = 1
                                navigationPath.append(conversation)
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

// FIX: Added required constant bindings for the preview
#Preview {
    MatchsResidencesView(
        selectedTab: .constant(0),
        navigationPath: .constant(NavigationPath())
    )
}
