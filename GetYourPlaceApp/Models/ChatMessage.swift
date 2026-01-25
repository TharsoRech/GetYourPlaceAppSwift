import SwiftUI

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isSender: Bool
    let timestamp: Date
}
