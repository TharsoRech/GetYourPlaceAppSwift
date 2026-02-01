import Foundation
import SwiftUI
import Combine

class RentalHistoryViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var rentals: [RentalHistory] = []
    
    private var rentalRunner = BackgroundTaskRunner<[RentalHistory]>()
    private let userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol = UserRepository()) {
        self.userRepository = userRepository
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
    
    func addRental(_ rental: RentalHistory) {
            withAnimation {
                self.rentals.insert(rental, at: 0)
            }
        }
    
    func deleteRental(at offsets: IndexSet) {
            // Removes from the local list
            self.rentals.remove(atOffsets: offsets)
        }
}
