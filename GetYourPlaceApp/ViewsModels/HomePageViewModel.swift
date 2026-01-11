import SwiftUI
import Combine


class HomePageViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var filters: [String] = []
    @Published var defaultFilter: String = ""
    @Published var residences: [Residence] = []
    @Published var showingFilters = false
    @Published var currentFilter = ResidenceFilter()
    private var residenceRunner = BackgroundTaskRunner<[Residence]>()
    private var citiesRunner = BackgroundTaskRunner<[String]>()
    
    private var cancellables = Set<AnyCancellable>()

    private let filteRepository: FilterRepositoryProtocol
    private let residenceRepository: ResidenceRepositoryProtocol
        
    init(filterRepository: FilterRepositoryProtocol =  FilterRepository(),
         residenceRepository: ResidenceRepositoryProtocol = ResidenceRepository()){
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
          showingFilters.toggle()
        }
    
    func ApplyDefaultFilter(filter : String) {
            defaultFilter = filter
            print("Default Filter clicked: \(defaultFilter)")
        }
    
    func GetRecentResidences() {
        residenceRunner.runInBackground {
            let results =  await self.residenceRepository.getRecentResidences()
            
            // Print the count and details of the results
            print("✅ Successfully fetched \(results.count) residences")
            for residence in results {
                print("🏠 Found: \(residence.name) at \(residence.location)")
            }
            
            await MainActor.run {
                self.residences = results;
            }
            
            return results
        }
    }
    
    func fetchFilters() async {
        self.filters = await filteRepository.getDefaultFilters()
    }
     
}

#Preview {
    HomePage()
}
