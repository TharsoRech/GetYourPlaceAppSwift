protocol ResidenceRepositoryProtocol {
    func getRecentResidences() async -> [Residence]
}
