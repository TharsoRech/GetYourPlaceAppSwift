import SwiftUI
import Combine


class HomePageViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var filters: [String] = []
    @Published var defaultFilter: String = ""
    @Published var residences: [Residence] = []
    private var runner = BackgroundTaskRunner<[Residence]>()
    
    private var cancellables = Set<AnyCancellable>()

    private let filteRepository: FilterRepositoryProtocol
    private let residenceRepository: ResidenceRepositoryProtocol
        
    init(filterRepository: FilterRepositoryProtocol =  FilterRepository(),
         residenceRepository: ResidenceRepositoryProtocol = ResidenceRepository() ){
        self.filteRepository = filterRepository;
        self.residenceRepository = residenceRepository;
        Task {
              await fetchFilters()
              GetRecentResidences()
            }
    }
    
    func PerformSearch() {
            print("Searching for: \(searchText)")
        }
    
    func FilterClicked() {
            print("Filter clicked: \(searchText)")
        }
    
    func ApplyDefaultFilter(filter : String) {
            defaultFilter = filter
            print("Default Filter clicked: \(defaultFilter)")
        }
    
    func GetRecentResidences() {
        runner.runInBackground {
            do {
                let results = try await self.residenceRepository.getRecentResidences()
                
                // Print the count and details of the results
                print("✅ Successfully fetched \(results.count) residences")
                for residence in results {
                    print("🏠 Found: \(residence.name) at \(residence.location)")
                }
                
                return results
            } catch {
                print("❌ Error fetching residences: \(error.localizedDescription)")
                return []
            }
        }
    }
    
    func fetchFilters() async {
        self.filters = await filteRepository.getDefaultFilters()
    }
     
}

#Preview {
    HomePage()
}
