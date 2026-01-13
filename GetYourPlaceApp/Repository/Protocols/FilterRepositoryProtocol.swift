protocol FilterRepositoryProtocol {
    func getDefaultFilters() async -> [String]
    
    func getCustomFilters() async -> ResidenceFilter
}
