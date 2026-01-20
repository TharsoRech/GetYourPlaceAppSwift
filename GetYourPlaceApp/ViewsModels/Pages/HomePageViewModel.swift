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
    @Published var selectedTab = "home"
    @Published var isLoading = false
    @Published var isFetchingMore = false
    @Published var allResidences: [Residence] = []
    
    private var currentPage = 1
    private var canLoadMore = true
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
            OrderResidences()
        }
    
    func OrderResidences() {
        self.isLoading = true
        switch defaultFilter {
        case "Price":
            residences.sort { $0.price < $1.price }
        case "Newest":
            // Note: Requires a 'createdAt' date property in Residence model
            residences.sort { $0.createdAt > $1.createdAt }
            print("Sorting by Newest")
        case "Rating":
            // Note: Requires a 'rating' property in Residence model
            residences.sort { $0.rating > $1.rating }
            print("Sorting by Rating")
        case "Distance":
            // Note: Requires location coordinates and user current location this can be implemented on the future
            print("Sorting by Distance")
        case "Category":
            residences.sort { $0.type < $1.type }
        default:
            residences.sort { $0.createdAt > $1.createdAt }
            break
        }
        self.isLoading = false
    }
    
    func ApplyCustomFilters(isApplied : Bool) {
        self.isFilterActive = isApplied

        if(isApplied){
            FilterResidences();
            print("filter set to Residences")
        }
        else{
            self.residences = self.allResidences;
            OrderResidences()
            print("filter set to allResidences")
        }
     }
    
    func GetRecentResidences() {
        
        residenceRunner.runInBackground {
            self.isLoading = true
            let results =  await self.residenceRepository.getRecentResidences()
            
            // Print the count and details of the results
            print("✅ Successfully fetched \(results.count) residences")
            for residence in results {
                print("🏠 Found: \(residence.name) at \(residence.location)")
            }
            
            await MainActor.run {
                self.allResidences = results;
                self.residences = results;
                self.isLoading = false;
                self.OrderResidences();
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
    
    func FilterResidences() {
        
        residenceRunner.runInBackground {
            await MainActor.run {
                self.isLoading = true
            }
  
            let results =  await self.residenceRepository.filterResidences(self.allResidences, with: self.currentFilter)
            
            // Print the count and details of the results
            print("✅ Successfully fetched \(results.count) residences")
            for residence in results {
                print("🏠 Found: \(residence.name) at \(residence.location)")
            }
            
            await MainActor.run {
                self.residences = results;
                self.isLoading = false
            }
            
            return results
        }
    }
    
    
    func loadNextPage() {
            // Prevent multiple simultaneous loads or loading when no data is left
            guard !isFetchingMore && !isLoading && canLoadMore else { return }
            
            residenceRunner.runInBackground {
                await MainActor.run {
                    self.isLoading = true;
                }
                
                await MainActor.run { self.isFetchingMore = true }
                
                let nextPage = self.currentPage + 1
                
                // repository call must support page parameter: getRecentResidences(page:)
                let results = await self.residenceRepository.getRecentResidences()
                
                await MainActor.run {
                    if results.isEmpty {
                        self.canLoadMore = false
                    } else {
                        self.residences.append(contentsOf: results)
                        self.currentPage = nextPage
                    }
                    self.isFetchingMore = false
                    self.isLoading = false;
                }
              
                return results
            }
        }
     
}

#Preview {
    HomePage()
}
