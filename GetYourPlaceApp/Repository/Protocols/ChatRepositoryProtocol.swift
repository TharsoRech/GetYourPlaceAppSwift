protocol ChatRepositoryProtocol {
    func getConversations() async -> [Conversation]
}
