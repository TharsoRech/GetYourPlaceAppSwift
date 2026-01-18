import Foundation

struct ResidenceFilter {
    var maxPrice: Double = 10000
    var maxSquareFootage: Double = 10000
    var selections: [String: String] = [:]
    var pickerOptions: [String: [String]] = [:]
    var cities: [String] = []
    var citySelected: String = ""
    var isApplyed: Bool = false
    
    static var mock: ResidenceFilter {
        var filter = ResidenceFilter()
        filter.maxPrice = 5000
        filter.maxSquareFootage = 2000
        filter.pickerOptions = [
            "Type": ["All", "Apartment", "House", "Villa", "Studio"],
            "Beds": ["1", "2", "3", "4+"],
            "Rooms": ["1", "2", "3", "4+"],
            "Garage": ["1", "2", "3", "4+"],
            "Baths": ["1", "2", "3", "4+"]
        ]
        filter.cities = ["New York", "Rio de Janeiro", "Budapest", "Atlanta", "London"]
        return filter
    }
}
