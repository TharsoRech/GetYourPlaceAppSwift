protocol ResidenceRepositoryProtocol {
    func getRecentResidences() async -> [Residence]
    
    func getResidences(nextPage: Int) async -> [Residence]
    
    func filterResidences(_ residences: [Residence], with filter: ResidenceFilter) async -> [Residence]
    
    func getPublishResidences() async -> [Residence] 
}
