import SwiftUI

struct ChatView: View {
    @Binding var title: String
    @Binding var messages: [ChatMessage]
    
    @State private var newMessageText: String = ""

    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.1, blue: 0.1)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                
                Divider()
                    .background(Color.gray.opacity(0.3))

                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(messages) { message in
                                ChatBubble(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: messages.count) { oldValue, newValue in
                        withAnimation {
                            proxy.scrollTo(messages.last?.id, anchor: .bottom)
                        }
                    }
                    .onAppear {
                        proxy.scrollTo(messages.last?.id, anchor: .bottom)
                    }
                }

                ChatInputView(text: $newMessageText) {
                    sendMessage()
                }
            }
            .padding(.bottom,84)
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
        .tint(.white)
    }

    private func sendMessage() {
        guard !newMessageText.isEmpty else { return }
        let newMsg = ChatMessage(text: newMessageText, isSender: true, timestamp: Date())
        messages.append(newMsg)
        newMessageText = ""
    }
}
#Preview("Chat Interface") {
    NavigationStack {
        ChatView(
            title: .constant("James Wilson"),
            messages: .constant([
                ChatMessage(text: "Hey! How's the project?", isSender: false, timestamp: Date()),
                ChatMessage(text: "Almost done!", isSender: true, timestamp: Date())
            ])
        )
        .navigationBarTitleDisplayMode(.inline)
    }
}
