import SwiftUI

struct ChatInputView: View {
    @Binding var text: String
    var onSend: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 12) {
                TextField("Message...", text: $text, axis: .vertical)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .lineLimit(1...5)

                Button(action: onSend) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 22))
                        .foregroundColor(text.isEmpty ? .gray : .white)
                }
                .disabled(text.isEmpty)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color(.black))
        }
    }
}

#Preview("Chat Input States") {
    VStack(spacing: 50) {
        VStack(alignment: .leading) {
            Text("Empty State").font(.caption).foregroundColor(.gray)
            ChatInputView(text: .constant(""), onSend: {})
        }
        
        VStack(alignment: .leading) {
            Text("Active State").font(.caption).foregroundColor(.gray)
            ChatInputView(text: .constant("Checking out this new UI!"), onSend: {})
        }
        
        VStack(alignment: .leading) {
            Text("Multi-line State").font(.caption).foregroundColor(.gray)
            ChatInputView(text: .constant("This is a longer message that will cause the text field to expand vertically because we set the axis to vertical."), onSend: {})
        }
    }
    .padding(.vertical)
    .background(Color(.systemGroupedBackground))
}
