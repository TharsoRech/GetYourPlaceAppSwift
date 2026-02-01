import SwiftUI

struct ChatMessage: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let isSender: Bool
    let timestamp: Date
}
