import SwiftUI
import Combine


class HomePageViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var filters: [String] = []
    @Published var defaultFilter: String = ""
    @Published var residences: [Residence] = []
    @Published var showingFilters = false
    @Published var currentFilter: ResidenceFilter
    @Published var isFilterActive: Bool
    private var residenceRunner = BackgroundTaskRunner<[Residence]>()
    private var citiesRunner = BackgroundTaskRunner<[String]>()
    private var defaultFilterRunner = BackgroundTaskRunner<[String]>()
    private var customFilterRunner = BackgroundTaskRunner<ResidenceFilter>()
    
    private var cancellables = Set<AnyCancellable>()

    private let filteRepository: FilterRepositoryProtocol
    private let residenceRepository: ResidenceRepositoryProtocol
        
    init(filterRepository: FilterRepositoryProtocol =  FilterRepository(),
         residenceRepository: ResidenceRepositoryProtocol = ResidenceRepository()){
        self.filteRepository = filterRepository;
        self.residenceRepository = residenceRepository;
        self.isFilterActive = false;
        self.currentFilter = ResidenceFilter();
        Task {
              fetchFilters()
              GetRecentResidences()
              fetchCustomFilters()
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
            print("Custom Filter clicked: \(defaultFilter)")
        }
    
    func ApplyCustomFilters() {
        self.isFilterActive = (currentFilter.selections.count) > 0
        
        print("--- 🔍 Applying Filters ---")
            if currentFilter.selections.isEmpty {
                print("No active selections.")
            } else {
                for (category, selection) in currentFilter.selections {
                    print("📍 \(category): \(selection)")
                }
            }
            
            // 3. Log numeric values
            print("💰 Max Price: \(currentFilter.maxPrice)")
            print("📏 Max SqFt: \(currentFilter.maxSquareFootage)")
            print("---------------------------")
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
    
    func fetchFilters() {
        defaultFilterRunner.runInBackground {
            let results = await self.filteRepository.getDefaultFilters()
            
            await MainActor.run {
                self.filters = results
            }
            
            return results;
        }
    }

    func fetchCustomFilters() {
        customFilterRunner.runInBackground {
            let results = await self.filteRepository.getCustomFilters()
            
            await MainActor.run {
                self.currentFilter = results
            }
            
            return results;
        }
    }
     
}

#Preview {
    HomePage()
}
