class FilterRepository: FilterRepositoryProtocol {
    func getDefaultFilters() async -> [String] {
        // Simulating API delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        return ["Price", "Distance", "Rating", "Newest", "Category"]
    }
}
