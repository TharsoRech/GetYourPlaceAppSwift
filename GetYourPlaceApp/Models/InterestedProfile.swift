import Foundation

struct InterestedProfile: Identifiable {
    let id = UUID()
    let name: String
    let residenceName: String
    let imageUrl: String
    var status: EngagementStatus = .pending
}
