import Foundation
import SwiftUI
import Combine

class ReviewsViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var reviews: [UserReview] = []
    
    private var rentalRunner = BackgroundTaskRunner<[UserReview]>()
    private let userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol = UserRepository()) {
        self.userRepository = userRepository
    }
    
    func fetchReviews() {
        guard !isLoading else { return }
        
        rentalRunner.runInBackground {
            await MainActor.run {
                self.isLoading = true
            }
            
            let results = await self.userRepository.getUserReviews()
            
            await MainActor.run {
                self.reviews = results
                self.isLoading = false
            }
            
            return results
        }
    }
}

