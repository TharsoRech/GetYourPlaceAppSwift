import Foundation
import SwiftUI

enum RentalStatus: String, Codable {
    case completed = "Completed"
    case upcoming = "Upcoming"
    case cancelled = "Cancelled"
    
    var color: Color {
        switch self {
        case .completed: return .green
        case .upcoming: return .blue
        case .cancelled: return .red
        }
    }
}

struct RentalHistory: Identifiable, Codable {
    let id: UUID
    let propertyName: String
    let location: String
    let startDate: Date
    let endDate: Date
    let status: RentalStatus
    
    // Formats: "Jan 12 - Jan 20, 2026"
    var dateRangeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let start = formatter.string(from: startDate)
        formatter.dateFormat = "MMM d, yyyy"
        let end = formatter.string(from: endDate)
        return "\(start) - \(end)"
    }
    
    static var mockArray: [RentalHistory] {
        [
            RentalHistory(
                id: UUID(),
                propertyName: "Luxury Villa",
                location: "Porto Alegre",
                startDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 12))!,
                endDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 20))!,
                status: .completed
            ),
            RentalHistory(
                id: UUID(),
                propertyName: "Beachfront Loft",
                location: "Florianópolis",
                startDate: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 5))!,
                endDate: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 12))!,
                status: .upcoming
            ),
            RentalHistory(
                id: UUID(),
                propertyName: "Mountain Cabin",
                location: "Gramado",
                startDate: Calendar.current.date(from: DateComponents(year: 2025, month: 12, day: 20))!,
                endDate: Calendar.current.date(from: DateComponents(year: 2025, month: 12, day: 27))!,
                status: .cancelled
            )
        ]
    }
}
