import SwiftUI

struct MatchsView: View {
    @State private var selectedTab = 0
    @State private var activeConversation: Conversation? = nil
    @Environment(AuthManager.self) var authManager
    
    init() {
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.lightGray], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        UISegmentedControl.appearance().backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        UISegmentedControl.appearance().selectedSegmentTintColor = .white
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 1. Header/Picker (Stays at the top)
            Picker("", selection: $selectedTab) {
                Text("Matchs").tag(0)
                Text("Chat").tag(1)
            }
            .pickerStyle(.segmented)
            .padding()
            .background(Color(red: 0.1, green: 0.1, blue: 0.1))
            
            // 2. Content Area
            ZStack {
                if selectedTab == 0 {
                    MatchsResidencesView(selectedTab: $selectedTab, activeConversation: $activeConversation)
                } else {
                    if let chat = activeConversation {
                        VStack {
                            HStack {
                                Button(action: { activeConversation = nil }) {
                                    HStack {
                                        Image(systemName: "chevron.left")
                                        Text("Back")
                                    }
                                    .foregroundColor(.white)
                                }
                                Spacer()
                            }
                            .padding()

                            ChatView(
                                title: .constant(chat.name),
                                messages: Binding(
                                    get: { activeConversation?.ConversationMessages ?? [] },
                                    set: { activeConversation?.ConversationMessages = $0 }
                                )
                            )
                        }
                        .transition(.move(edge: .trailing))
                    } else {
                        ConversationsListView(selectedTab: $selectedTab, activeConversation: $activeConversation)
                    }
                }
            }
            
            Spacer(minLength: 0)
        }
        .background(Color(red: 0.1, green: 0.1, blue: 0.1).ignoresSafeArea())
        .animation(.default, value: activeConversation)
    }
}

#Preview("Owner View") {
    MatchsView()
        .environment(AuthManager.mock(role: .owner))
}

#Preview("Renter View") {
    MatchsView()
        .environment(AuthManager.mock(role: .renter))
}
