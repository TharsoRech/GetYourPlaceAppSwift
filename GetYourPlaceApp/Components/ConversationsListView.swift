import SwiftUI

struct ConversationsListView: View {
    @Binding var chatList: [Conversation]
    
    var body: some View {
        NavigationStack {
            List($chatList) { $chat in
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
    @Previewable @State var mockData = [
        Conversation(
            name: "James Wilson",
            time: "10:24 AM",
            imageName: "person.circle.fill",
            unreadCount: 2,
            ConversationMessages: [
                ChatMessage(text: "Are we still meeting at 5?", isSender: false, timestamp: Date())
            ]
        ),
        Conversation(
            name: "Sarah Parker",
            time: "Yesterday",
            imageName: "person.crop.circle",
            unreadCount: 0,
            ConversationMessages: [
                ChatMessage(text: "The new UI looks great!", isSender: false, timestamp: Date())
            ]
        )
    ]
    
    return ConversationsListView(chatList: $mockData)
}
