protocol ChatRepositoryProtocol {
    func getConversations() async -> [Conversation]
    
    func getConversation(profile: InterestedProfile) async -> Conversation
}
