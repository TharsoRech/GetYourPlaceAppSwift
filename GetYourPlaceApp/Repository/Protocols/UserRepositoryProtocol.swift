protocol UserRepositoryProtocol {
    func getUserConfiguration() async -> UserProfile
    
    func getUserReviews() async -> [UserReview]
    
    func getRentalHistory() async -> [RentalHistory]
}

