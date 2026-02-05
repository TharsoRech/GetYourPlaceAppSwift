import Foundation
class ResidenceRepository: ResidenceRepositoryProtocol {
    func getInterestedResidences() async -> [Residence] {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        return Residence.mocks
    }
    
    
    func getFavoritesResidences() async -> [Residence] {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        return Residence.mocks
    }
    


    func getRecentResidences() async -> [Residence] {
        // Simulando delay de rede
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        return Residence.mocks
    }
    
    func getResidences(nextPage: Int) async -> [Residence] {
        // Simulando delay de rede
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        return Residence.mocks
    }
    
    func filterResidences(_ residences: [Residence], with filter: ResidenceFilter) async -> [Residence] {
        return residences.filter { residence in
            
            // --- 1. Property-based Filters ---
            
            // Price (Only if maxPrice is set above 0)
            if filter.maxPrice > 0 && residence.price > filter.maxPrice { return false }
            
            // Square Footage
            if filter.maxSquareFootage > 0 && residence.squareFootage > filter.maxSquareFootage { return false }
            
            // City Match
            if !filter.citySelected.isEmpty && filter.citySelected != "All" {
                if !residence.location.localizedCaseInsensitiveContains(filter.citySelected) {
                    return false
                }
            }
            
            // --- 2. Selection Dictionary Filters ---
            
            for (key, selectedValue) in filter.selections {
                guard selectedValue != "All", !selectedValue.isEmpty else { continue }
                
                let isMatch: Bool
                switch key {
                case "Type":
                    isMatch = residence.type == selectedValue
                case "Beds":
                    isMatch = FilterMatcher.check(residence.numberOfBeds, satisfies: selectedValue)
                case "Rooms":
                    isMatch = FilterMatcher.check(residence.numberOfRooms, satisfies: selectedValue)
                case "Baths":
                    isMatch = FilterMatcher.check(residence.baths, satisfies: selectedValue)
                case "Garage":
                    isMatch = FilterMatcher.check(residence.numberOfGarages, satisfies: selectedValue)
                default:
                    isMatch = true
                }
                
                if !isMatch { return false }
            }
            
            return true
        }
    }
    
    func getPublishResidences() async -> [Residence] {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        return Residence.mocks.filter { $0.isMine }
    }
}

