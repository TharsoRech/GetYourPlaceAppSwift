protocol FilterRepositoryProtocol {
    func getDefaultFilters() async -> [String]
}
