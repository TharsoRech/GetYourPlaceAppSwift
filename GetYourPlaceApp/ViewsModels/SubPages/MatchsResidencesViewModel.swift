import Foundation
import SwiftUI
import Combine

class MatchsResidencesViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var conversations: [Conversation] = []
    @Published var selectedChatProfile: InterestedProfile?
    @Published var profiles: [InterestedProfile] = []
    
    private var conversationRunner = BackgroundTaskRunner<[Conversation]>()
    private var profileRunner = BackgroundTaskRunner<[InterestedProfile]>()
    private let chatRepository: ChatRepositoryProtocol
    private let matchsRepository: MatchsRepositoryProtocol
    private var profileChatRunner = BackgroundTaskRunner<InterestedProfile>()
        
    init(chatRepository: ChatRepositoryProtocol = ChatRepository(),
         matchsRepository: MatchsRepositoryProtocol = MatchsRepository()){
        self.chatRepository = chatRepository;
        self.matchsRepository = matchsRepository;
        Task {
            fetchConversations()
            fetchMatchs()
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
    
    func fetchMatchs() {
        profileRunner.runInBackground {
            
            await MainActor.run {
                self.isLoading = true
            }
            
            let results = await self.matchsRepository.getMatchs()
            
            await MainActor.run {
                self.profiles = results
            }
            
            await MainActor.run {
                self.isLoading = false
            }
            
            return results
        }
    }
    
    func openChat(for profile: InterestedProfile) {
        selectedChatProfile = profile
    }
    
    @MainActor
    func getConversation(profile: InterestedProfile) async -> Conversation {
        self.isLoading = true
        
        // The actual data fetching happens in the background (via the Repository)
        // but the execution resumes here on the Main Thread.
        let result = await self.chatRepository.getConversation(profile: profile)
        
        self.isLoading = false
        return result
    }
     
}
