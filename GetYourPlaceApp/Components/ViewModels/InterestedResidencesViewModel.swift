import Foundation
import SwiftUI
import Combine

class InterestedResidencesViewModel: ObservableObject {
    @Published var interestedResidences: [Residence] = []
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
            let results =  await self.residenceRepository.getInterestedResidences()
            
            // Print the count and details of the results
            print("✅ Successfully fetched \(results.count) interseted residences")
            for residence in results {
                print("🏠 Found interested Residence: \(residence.name) at \(residence.location)")
            }
            
            await MainActor.run {
                self.interestedResidences = results;
                self.isLoading = false
            }

            return results
        }
    }
     
}

#Preview {
    let mockVM = InterestedResidencesViewModel()
    
    InterestedResidencesView(viewModel: mockVM)
        .environment(AuthManager.mock(role: .owner))
}
