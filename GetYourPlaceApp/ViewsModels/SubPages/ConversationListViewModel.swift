import Foundation
import SwiftUI
import Combine

class ConversationListViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var conversations: [Conversation] = []
    
    private var conversationRunner = BackgroundTaskRunner<[Conversation]>()
    private let chatRepository: ChatRepositoryProtocol
        
    init(chatRepository: ChatRepositoryProtocol = ChatRepository()){
        self.chatRepository = chatRepository;
        Task {
            fetchConversations()
        }
    }
    
    func fetchConversations() {
        conversationRunner.runInBackground {
            
            await MainActor.run {
                self.isLoading = true
            }
            
            let results = await self.chatRepository.getConversations()
            
            await MainActor.run {
                self.conversations = results
            }
            
            await MainActor.run {
                self.isLoading = false
            }
            
            return results
        }
    }
     
}
