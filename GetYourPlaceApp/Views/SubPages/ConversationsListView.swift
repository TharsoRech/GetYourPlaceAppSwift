import SwiftUI

struct ConversationsListView: View {
    @StateObject private var viewModel: ConversationListViewModel
    @Binding var navigationPath: NavigationPath
    
    init(navigationPath: Binding<NavigationPath>, viewModel: @autoclosure @escaping () -> ConversationListViewModel = ConversationListViewModel()) {
        self._navigationPath = navigationPath
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            Group {
                if viewModel.isLoading {
                    List(0..<3) { _ in
                        ConversationRowSkeleton()
                            .listRowBackground(Color.clear)
                    }
                } else {
                    List(viewModel.conversations) { chat in
                        // This now works because Conversation is Hashable
                        NavigationLink(value: chat) {
                            ConversationRow(conversation: chat)
                        }
                        .listRowBackground(Color.clear)
                    }
                }
            }
            // This now works because Conversation is Hashable
            .navigationDestination(for: Conversation.self) { chat in
                ChatView(title: .constant(chat.name), messages: .constant(chat.ConversationMessages))
            }
            .listStyle(.plain)
            .animation(.easeInOut, value: viewModel.isLoading)
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            .background(Color(red: 0.1, green: 0.1, blue: 0.1).ignoresSafeArea())
        }
        .tint(.white)
    }
}

#Preview {
    // Note: Ensure AuthManager is an ObservableObject
    ConversationsListView(navigationPath: .constant(NavigationPath()))
        .environmentObject(AuthManager.mock(role: .renter))
}
