import Foundation
class ResidenceRepository: ResidenceRepositoryProtocol {
    func getRecentResidences() async -> [Residence] {
        // Simulando delay de rede
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        return [
            Residence(
                name: "Modern Villa",
                address: "123 luxury Way",
                location: "Los Angeles, CA",
                type: "House",
                price: 2500000.0,
                numberOfRooms: 8,
                numberOfBeds: 4,
                baths: 3,
                squareFootage: 3500.0,
                hasGarage: true,
                numberOfGarages: 1,
                rating: 5.0,
                createdAt: Date().addingTimeInterval(-10000),
                mainImageBase64: "house1".asAssetBase64, // Nome do Asset
                galleryImagesBase64: ["house1".asAssetBase64, "house1".asAssetBase64]
            ),
            Residence(
                name: "Skyline Apartment",
                address: "888 Central Ave",
                location: "New York, NY",
                type: "House",
                price: 950000.0,
                numberOfRooms: 3,
                numberOfBeds: 1,
                baths: 1,
                squareFootage: 850.0,
                hasGarage: false,
                numberOfGarages: 1,
                rating: 3.0,
                createdAt: Date().addingTimeInterval(-20000),
                mainImageBase64: "house2".asAssetBase64,
                galleryImagesBase64: ["house2".asAssetBase64]
            ),
            Residence(
                name: "Cozy Cottage",
                address: "42 Forest Road",
                location: "Aspen, CO",
                type: "Apartment",
                price: 1200000.0,
                numberOfRooms: 5,
                numberOfBeds: 3,
                baths: 2,
                squareFootage: 1800.0,
                hasGarage: true,
                numberOfGarages: 1,
                rating: 4.0,
                createdAt: Date(),
                mainImageBase64: "house3".asAssetBase64,
                galleryImagesBase64: []
            )
        ]
    }
    
    func getResidences(nextPage: Int) async -> [Residence] {
        // Simulando delay de rede
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        return [
            Residence(
                name: "Modern Villa",
                address: "123 luxury Way",
                location: "Los Angeles, CA",
                type: "House",
                price: 2500000.0,
                numberOfRooms: 8,
                numberOfBeds: 4,
                baths: 3,
                squareFootage: 3500.0,
                hasGarage: true,
                numberOfGarages: 1,
                rating: 4.0,
                createdAt: Date().addingTimeInterval(-10000),
                mainImageBase64: "house1".asAssetBase64, // Nome do Asset
                galleryImagesBase64: ["house1".asAssetBase64, "house1".asAssetBase64]
            ),
            Residence(
                name: "Skyline Apartment",
                address: "888 Central Ave",
                location: "New York, NY",
                type: "House",
                price: 950000.0,
                numberOfRooms: 3,
                numberOfBeds: 1,
                baths: 1,
                squareFootage: 850.0,
                hasGarage: false,
                numberOfGarages: 1,
                rating: 4.0,
                createdAt: Date().addingTimeInterval(-20000),
                mainImageBase64: "house2".asAssetBase64,
                galleryImagesBase64: ["house2".asAssetBase64]
            ),
            Residence(
                name: "Cozy Cottage",
                address: "42 Forest Road",
                location: "Aspen, CO",
                type: "Apartment",
                price: 1200000.0,
                numberOfRooms: 5,
                numberOfBeds: 3,
                baths: 2,
                squareFootage: 1800.0,
                hasGarage: true,
                numberOfGarages: 1,
                rating: 4.0,
                createdAt: Date(),
                mainImageBase64: "house3".asAssetBase64,
                galleryImagesBase64: []
            )
        ]
    }
    
    func filterResidences(_ residences: [Residence], with filter: ResidenceFilter) async -> [Residence] {
        return residences.filter { residence in
            let s = filter.selections
            
            // Iterate through every active filter in the selections dictionary
            for (key, selectedValue) in s {
                // Skip filtering if "All" is selected or if the value is empty
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
                    isMatch = true // Ignore unknown keys
                }
                
                // If any single criteria fails, the whole residence is excluded
                if !isMatch { return false }
            }
            
            return true
        }
    }
}

