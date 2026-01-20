import Foundation

struct ResidenceFilter {
    var maxPrice: Double = 0
    var maxSquareFootage: Double = 0
    var selections: [String: String] = [:]
    var pickerOptions: [String: [String]] = [:]
    var cities: [String] = []
    var citySelected: String = ""
    
    static var mock: ResidenceFilter {
        var filter = ResidenceFilter()
        filter.maxPrice = 5000
        filter.maxSquareFootage = 2000
        filter.pickerOptions = [
            "Type": ["All", "Apartment", "House", "Villa", "Studio"],
            "Beds": ["None","1", "2", "3", "4+"],
            "Rooms": ["None","1", "2", "3", "4+"],
            "Garage": ["None","1", "2", "3", "4+"],
            "Baths": ["None","1", "2", "3", "4+"]
        ]
        filter.cities = ["New York", "Rio de Janeiro", "Budapest", "Atlanta", "London"]
        return filter
    }
}
