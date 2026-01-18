class FilterRepository: FilterRepositoryProtocol {
    func getDefaultFilters() async -> [String] {
        // Simulating API delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        return ["Newest","Price", "Rating", "Category"]
    }
    
    func getCustomFilters() async -> ResidenceFilter {
        // Simulating API delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        return ResidenceFilter(
            maxPrice: 5000,
            maxSquareFootage: 2000,
            selections: [:],
            pickerOptions: [
                "Type": ["All", "Apartment", "House", "Villa", "Studio"],
                "Beds": ["1", "2", "3", "4+"],
                "Rooms": ["1", "2", "3", "4+"],
                "Garage": ["1", "2", "3", "4+"],
                "Baths": ["1", "2", "3", "4+"]
            ],
            cities: ["New York", "Rio de Janeiro", "Budapest", "Atlanta", "London"]
        )
    }
}
