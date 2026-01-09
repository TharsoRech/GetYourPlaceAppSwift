import Foundation

struct ResidenceFilter {
    var maxPrice: Double = 5000
    var residenceType: String = "All"
    let types = ["All", "Apartment", "House", "Villa", "Studio"]
}
