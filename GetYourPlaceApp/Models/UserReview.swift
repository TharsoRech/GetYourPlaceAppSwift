import Foundation

struct UserReview: Identifiable, Codable {
    let id: UUID
    let rating: Double
    let comment: String
    let date: Date
    let reviewerName: String
    
    var relativeDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }

    static var mockArray: [UserReview] {
        [
            UserReview(
                id: UUID(),
                rating: 5.0,
                comment: "Great guest! Highly recommended. Left the place spotless.",
                date: Date().addingTimeInterval(-172800), // 2 days ago
                reviewerName: "Sarah"
            ),
            UserReview(
                id: UUID(),
                rating: 4.8,
                comment: "Very communicative and followed all the house rules perfectly.",
                date: Date().addingTimeInterval(-604800), // 7 days ago
                reviewerName: "John"
            ),
            UserReview(
                id: UUID(),
                rating: 5.0,
                comment: "Awesome experience, would host again anytime!",
                date: Date().addingTimeInterval(-1209600), // 14 days ago
                reviewerName: "Mike"
            )
        ]
    }
}
