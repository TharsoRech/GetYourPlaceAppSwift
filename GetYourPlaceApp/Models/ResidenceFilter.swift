import Foundation

struct ResidenceFilter {
    var maxPrice: Double = 5000
    var maxSquareFootage: Double = 2000
    var selections: [String: String] = [:]
    let pickerOptions: [String: [String]] = [
            "Type": ["All", "Apartment", "House", "Villa", "Studio"],
            "Beds": ["1", "2", "3", "4+"],
            "Rooms": ["1", "2", "3", "4+"],
            "Garage": ["1", "2", "3", "4+"],
            "Baths": ["1", "2", "3", "4+"],
        ]
    
    var cities: [String] = ["New York", "Rio de Janeiro", "Budapest", "Atlanta", "London"]
}
