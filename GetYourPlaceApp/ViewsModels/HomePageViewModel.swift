import SwiftUI


class HomePageViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var filters: [String] = []
    @Published var defaultFilter: String = ""

    private let repository: FilterRepositoryProtocol
        
    init(repository: FilterRepositoryProtocol = FilterRepository()) {
            self.repository = repository
        Task {
              await fetchFilters()
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
    
    @MainActor
        func fetchFilters() async {
            self.filters = await repository.getDefaultFilters()
        }
}

#Preview {
    HomePage()
}
