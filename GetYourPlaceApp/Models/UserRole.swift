enum UserRole: String, CaseIterable, Codable { // Added Codable here
    case owner = "Owner"
    case renter = "Renter"
    
    var description: String {
        switch self {
        case .owner: return "I want to list my property"
        case .renter: return "I am looking for a place"
        }
    }
    
    var icon: String {
        switch self {
        case .owner: return "house.fill"
        case .renter: return "person.fill"
        }
    }
}
