import SwiftUI

struct ChatMessage: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let isSender: Bool
    let timestamp: Date
}

extension ChatMessage {
    static var mock: ChatMessage {
        ChatMessage(
            text: "Hey! Is the property still available for this weekend?",
            isSender: false,
            timestamp: Date()
        )
    }
}
