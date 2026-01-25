import SwiftUI

struct ConversationRow: View {
    let conversation: Conversation
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: conversation.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 55, height: 55)
                .background(Color.white.opacity(0.1))
                .clipShape(Circle())
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(conversation.name)
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Text(conversation.time)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text(conversation.lastMessage)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if conversation.unreadCount > 0 {
                        Text("\(conversation.unreadCount)")
                            .font(.caption2).bold()
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.red)
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview("Conversation Row States") {
    List {
        // State 1: New message with unread badge
        ConversationRow(conversation: Conversation(
            name: "James Wilson",
            time: "10:24 AM",
            imageName: "person.circle.fill",
            unreadCount: 2,
            ConversationMessages: [] // <--- Add this
        ))
        
        // State 2: Read message (No badge)
        ConversationRow(conversation: Conversation(
            name: "Sarah Parker",
            time: "Yesterday",
            imageName: "person.crop.circle.badge.checkmark",
            unreadCount: 0,
            ConversationMessages: [] // <--- Add this
        ))
    }
    .listStyle(.plain)
}
