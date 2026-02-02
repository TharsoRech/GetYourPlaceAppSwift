import SwiftUI

struct Conversation: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var lastMessage: String {
        ConversationMessages.last?.text ?? "No messages yet"
    }
    var time: String
    var imageName: String
    var unreadCount: Int
    var ConversationMessages: [ChatMessage] // Now Swift knows how to hash this!
}

extension Conversation {
    static var mock: Conversation {
        Conversation(
            name: "Jordan Lee",
            time: "10:30 AM",
            imageName: "person.crop.circle.fill",
            unreadCount: 3,
            ConversationMessages: [
                ChatMessage.mock,
                ChatMessage.mock,
                ChatMessage.mock
            ]
        )
    }
}
