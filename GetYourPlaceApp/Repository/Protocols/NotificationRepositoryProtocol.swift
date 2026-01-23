protocol NotificationRepositoryProtocol {
    func getNotifications() async -> [String]
}
