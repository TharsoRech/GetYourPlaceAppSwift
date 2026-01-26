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
    @Published var isLoading = false
    @Published var isFetchingMore = false
    @Published var allResidences: [Residence] = []
    @Published var newNotifications: [String] = []
    @Published var conversations: [Conversation] = []
    @Published var profile: UserProfile
    
    private var currentPage = 1
    private var canLoadMore = true
    private var residenceRunner = BackgroundTaskRunner<[Residence]>()
    private var citiesRunner = BackgroundTaskRunner<[String]>()
    private var defaultFilterRunner = BackgroundTaskRunner<[String]>()
    private var customFilterRunner = BackgroundTaskRunner<ResidenceFilter>()
    private var notificationRunner = BackgroundTaskRunner<[String]>()
    private var conversationRunner = BackgroundTaskRunner<[Conversation]>()
    
    private var cancellables = Set<AnyCancellable>()
    private var profileRunner = BackgroundTaskRunner<UserProfile>()

    private let filteRepository: FilterRepositoryProtocol
    private let residenceRepository: ResidenceRepositoryProtocol
    private let notificationRepository: NotificationRepositoryProtocol
    private let chatRepository: ChatRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
        
    init(filterRepository: FilterRepositoryProtocol =  FilterRepository(),
         residenceRepository: ResidenceRepositoryProtocol = ResidenceRepository(),
         notificationRepository: NotificationRepositoryProtocol = NotificationRepository()
         ,chatRepository: ChatRepositoryProtocol = ChatRepository()
        ,userRepository: UserRepositoryProtocol = UserRepository()){
        self.filteRepository = filterRepository;
        self.residenceRepository = residenceRepository;
        self.notificationRepository = notificationRepository;
        self.userRepository = userRepository;
        self.chatRepository = chatRepository;
        self.isFilterActive = false;
        self.currentFilter = ResidenceFilter();
        self.profile = UserProfile()
        Task {
              fetchFilters()
              GetRecentResidences()
              fetchCustomFilters()
              fetchNotifications()
              fetchConversations()
              fetchUserProfile()
        }
    }
    
    func PerformSearch() {
        print("Searching for: \(searchText)")
        
        // 1. If search text is empty and no filters are active, show everything
        guard !searchText.isEmpty else {
            if isFilterActive {
                FilterResidences() // Re-apply custom filters if they exist
            } else {
                self.residences = self.allResidences
                OrderResidences()
            }
            return
        }
        
        // 2. Filter the existing data based on text
        // We filter from 'allResidences' to ensure we search the full dataset
        let filtered = allResidences.filter { residence in
            let nameMatch = residence.name.localizedCaseInsensitiveContains(searchText)
            let addressMatch = residence.address.localizedCaseInsensitiveContains(searchText)
            let locationMatch = residence.location.localizedCaseInsensitiveContains(searchText)
            
            return nameMatch || addressMatch || locationMatch
        }
        
        // 3. Update the UI
        Task { @MainActor in
            self.residences = filtered
            
            // 4. If custom filters (Baths, Beds, etc.) are also active,
            // we should narrow down the search results further
            if isFilterActive {
                self.residences = await self.residenceRepository.filterResidences(self.residences, with: self.currentFilter)
            }
            
            OrderResidences()
        }
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
            OrderResidences();
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
    
    func fetchNotifications() {
        notificationRunner.runInBackground {
            await MainActor.run {
                self.isLoading = true
            }
            let results = await self.notificationRepository.getNotifications()
            
            await MainActor.run {
                self.isLoading = false
                self.newNotifications = results
            }
            
            return results;
        }
    }
    
    func fetchConversations() {
        conversationRunner.runInBackground {
            let results = await self.chatRepository.getConversations()
            
            await MainActor.run {
                self.conversations = results
            }
            
            return results
        }
    }
    
    func fetchUserProfile() {
        profileRunner.runInBackground {
            let results = await self.userRepository.getUserConfiguration()
            
            await MainActor.run {
                self.profile = results
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
