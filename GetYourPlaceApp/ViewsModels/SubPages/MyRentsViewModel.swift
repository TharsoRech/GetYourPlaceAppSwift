import Foundation
import SwiftUI
import Combine

class MyRentsViewModel: ObservableObject {
    @Published var publishResidences: [Residence] = []
    @Published var isLoading = false
    @Published var isFetchingMore = false
    
    private var residenceRunner = BackgroundTaskRunner<[Residence]>()
    private let residenceRepository: ResidenceRepositoryProtocol
        
    init(residenceRepository: ResidenceRepositoryProtocol = ResidenceRepository()){
        self.residenceRepository = residenceRepository;
        Task {
            GetPublishResidences()
        }
    }
    
  
    func GetPublishResidences() {
        
        residenceRunner.runInBackground {
            await MainActor.run {
                self.isLoading = true
            }
            let results =  await self.residenceRepository.getPublishResidences()
            
            // Print the count and details of the results
            print("✅ Successfully fetched \(results.count) published residences")
            for residence in results {
                print("🏠 Found Published Residence: \(residence.name) at \(residence.location)")
            }
            
            await MainActor.run {
                self.publishResidences = results;
                self.isLoading = false
            }

            return results
        }
    }
    
    func handleSave(_ residence: Residence) {
        if let index = publishResidences.firstIndex(where: { $0.id == residence.id }) {
            publishResidences[index] = residence
        } else {
            publishResidences.append(residence)
        }
    }
     
}

#Preview {
    MyRents()
}
