import SwiftUI

struct ConversationsListView: View {
    @StateObject private var viewModel: ConversationListViewModel
    @Binding var activeConversation: Conversation?
    @Binding var selectedTab: Int
    
    init(selectedTab: Binding<Int>,
         activeConversation: Binding<Conversation?>,
         viewModel: @autoclosure @escaping () -> ConversationListViewModel = ConversationListViewModel()) {
        self._selectedTab = selectedTab
        self._activeConversation = activeConversation
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        ZStack {
            // Consistent app background
            Color(red: 0.1, green: 0.1, blue: 0.1).ignoresSafeArea()
            
            Group {
                if viewModel.isLoading {
                    List(0..<3, id: \.self) { _ in
                        ConversationRowSkeleton()
                            .listRowBackground(Color.clear)
                    }
                } else {
                    List(viewModel.conversations) { chat in
                        Button {
                            activeConversation = chat
                        } label: {
                            ConversationRow(conversation: chat)
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(Color.clear)
                    }
                }
            }
            .listStyle(.plain)
            .animation(.easeInOut, value: viewModel.isLoading)
            .scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    ConversationsListView(
        selectedTab: .constant(1),
        activeConversation: .constant(Conversation.mock)
    )
    .environment(AuthManager.mock(role: .renter))
}
