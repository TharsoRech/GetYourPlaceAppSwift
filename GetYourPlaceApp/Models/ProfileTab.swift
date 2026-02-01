enum ProfileTab: String, CaseIterable {
    case account = "Account"
    case personal = "Personal"
    case rentals = "Rentals"
    case reviews = "Reviews"
    
    var icon: String {
        switch self {
        case .account: return "person.fill"
        case .personal: return "info.circle.fill"
        case .rentals: return "house.and.flag.fill"
        case .reviews: return "star.fill"
        }
    }
}
