import SwiftUI
import Observation

@Observable
class PublicProfileViewModel {
    var isLoading = false
    var rentals: [RentalHistory] = []
    var reviews: [UserReview] = []
    var profile: UserProfile?
    
    private var reviewRunner = BackgroundTaskRunner<[UserReview]>()
    private var rentalRunner = BackgroundTaskRunner<[RentalHistory]>()
    private var profileRunner = BackgroundTaskRunner<UserProfile>()
    private let userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol = UserRepository()) {
        self.userRepository = userRepository
        fetchUserProfile()
        fetchRentals()
        fetchReviews()
    }
    
    func fetchRentals() {

        guard !isLoading else { return }
        
        rentalRunner.runInBackground {
            await MainActor.run {
                self.isLoading = true
            }
            
            let results = await self.userRepository.getRentalHistory()
            
            await MainActor.run {
                self.rentals = results
                self.isLoading = false
            }
            
            return results
        }
    }
    
    func fetchReviews() {
        guard !isLoading else { return }
        
        reviewRunner.runInBackground {
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
    
    func fetchUserProfile() {
        guard !isLoading else { return }
        
        profileRunner.runInBackground {
            await MainActor.run {
                self.isLoading = true
            }
            
            let results = await self.userRepository.getUserConfiguration()
            
            await MainActor.run {
                self.profile = results
                self.isLoading = false
            }
            
            return results
        }
    }
    
    func addReview(_ review: UserReview) {
        reviews.insert(review, at: 0)
    }
}
