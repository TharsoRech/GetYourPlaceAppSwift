import SwiftUI

struct StatusBadge: View {
    let status: String // e.g., "Pending", "Approved", "Declined"
    
    var body: some View {
        Text(status.uppercased())
            .font(.system(size: 10, weight: .bold))
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .foregroundColor(statusColor.opacity(1.0))
            .background(statusColor.opacity(0.2))
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(statusColor.opacity(0.5), lineWidth: 1)
            )
    }
    
    private var statusColor: Color {
        switch status.lowercased() {
        case "approved": return .green
        case "pending": return .orange
        case "declined": return .red
        default: return .blue
        }
    }
}
