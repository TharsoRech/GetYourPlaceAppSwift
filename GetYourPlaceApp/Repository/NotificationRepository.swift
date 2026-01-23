class NotificationRepository: NotificationRepositoryProtocol {
    func getNotifications() async -> [String] {
        // Simulating API delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        return [
            "James showed interest in your residence",
            "New login from Chrome",
            "Your subscription was renewed"
        ]
    }
}
