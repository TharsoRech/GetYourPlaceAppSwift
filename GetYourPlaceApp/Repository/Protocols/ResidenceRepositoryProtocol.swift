protocol ResidenceRepositoryProtocol {
    func getRecentResidences() async -> [Residence]
    
    func getResidences(nextPage: Int) async -> [Residence]
}
