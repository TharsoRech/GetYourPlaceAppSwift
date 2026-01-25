import Foundation
class ChatRepository: ChatRepositoryProtocol {
    func getConversations() async -> [Conversation] {
        // Simulate network latency (0.5 seconds)
        try? await Task.sleep(for: .seconds(2))
        
        return [
            Conversation(
                name: "James Wilson",
                time: "10:24 AM",
                imageName: "person.circle.fill",
                unreadCount: 2,
                ConversationMessages: [
                    ChatMessage(text: "Hey! How's the project going?", isSender: false, timestamp: Date().addingTimeInterval(-3600)),
                    ChatMessage(text: "Are we still meeting at 5?", isSender: false, timestamp: Date())
                ]
            ),
            Conversation(
                name: "Sarah Parker",
                time: "Yesterday",
                imageName: "person.crop.circle",
                unreadCount: 0,
                ConversationMessages: [
                    ChatMessage(text: "The new UI looks great!", isSender: false, timestamp: Date().addingTimeInterval(-86400))
                ]
            ),
            Conversation(
                name: "Tech Support",
                time: "Monday",
                imageName: "headphones",
                unreadCount: 1,
                ConversationMessages: [
                    ChatMessage(text: "Your ticket #1234 has been updated.", isSender: false, timestamp: Date().addingTimeInterval(-172800))
                ]
            )
        ]
    }
}
