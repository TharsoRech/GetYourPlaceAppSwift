import SwiftUI

struct ConversationsListView: View {
    @StateObject var viewModel: ConversationListViewModel
    
    init(viewModel: ConversationListViewModel = ConversationListViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            List($viewModel.conversations) { $chat in
                NavigationLink {
                    ChatView(title: $chat.name, messages: $chat.ConversationMessages)
                } label: {
                    ConversationRow(conversation: chat)
                }
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: 20)
            }
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Messages")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(red: 0.1, green: 0.1, blue: 0.1).ignoresSafeArea())
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .tint(.white)
    }
}

#Preview {
    return ConversationsListView().environment(AuthManager.mock(role: .renter))
}
