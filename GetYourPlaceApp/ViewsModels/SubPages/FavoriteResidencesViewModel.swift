import Foundation
import SwiftUI
import Combine

class FavoriteResidencesViewModel: ObservableObject {
    @Published var favoritesResidences: [Residence] = []
    @Published var isLoading = false
    @Published var isFetchingMore = false
    
    private var residenceRunner = BackgroundTaskRunner<[Residence]>()
    private let residenceRepository: ResidenceRepositoryProtocol
        
    init(residenceRepository: ResidenceRepositoryProtocol = ResidenceRepository()){
        self.residenceRepository = residenceRepository;
        Task {
            GetFavoritesResidences()
        }
    }
    
  
    func GetFavoritesResidences() {
        
        residenceRunner.runInBackground {
            await MainActor.run {
                self.isLoading = true
            }
            let results =  await self.residenceRepository.getFavoritesResidences()
            
            // Print the count and details of the results
            print("✅ Successfully fetched \(results.count) favorites residences")
            for residence in results {
                print("🏠 Found favorites Residence: \(residence.name) at \(residence.location)")
            }
            
            await MainActor.run {
                self.favoritesResidences = results;
                self.isLoading = false
            }

            return results
        }
    }
     
}

#Preview {
    FavoriteResidences()
}
