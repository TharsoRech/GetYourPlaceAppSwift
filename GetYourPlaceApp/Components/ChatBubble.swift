import SwiftUI

struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isSender { Spacer() }
            
            Text(message.text)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(message.isSender ? Color.black : Color(.systemGray5))
                .foregroundColor(message.isSender ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .padding(message.isSender ? .leading : .trailing, 60)
            
            if !message.isSender { Spacer() }
        }
    }
}

#Preview("Chat Bubbles") {
    VStack(spacing: 20) {
        ChatBubble(message: ChatMessage(
            text: "Short message",
            isSender: false,
            timestamp: Date()
        ))
        
        ChatBubble(message: ChatMessage(
            text: "This is a much longer message to see how the text wraps within the bubble logic we created.",
            isSender: true,
            timestamp: Date()
        ))
    }
    .padding()
}
