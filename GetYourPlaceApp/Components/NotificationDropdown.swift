import SwiftUI

struct NotificationDropdown: View {
    // FIX: Explicitly define the type and do not assign a default value to a Binding
    @Binding var notifications: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Little arrow pointing up
            HStack {
                Spacer()
                Triangle()
                    .fill(Color(red: 0.1, green: 0.1, blue: 0.1))
                    .frame(width: 20, height: 10)
                    .padding(.trailing, 10)
            }
            
            // The List Container
            VStack(alignment: .leading, spacing: 15) {
                Text("Notifications")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                if notifications.isEmpty {
                    Text("No new notifications")
                        .font(.subheadline)
                        .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1))
                        .padding(.vertical)
                } else {
                    ForEach(notifications, id: \.self) { note in
                        HStack(alignment: .top) {
                            Circle()
                                .fill(Color(red: 0.1, green: 0.1, blue: 0.1))
                                .frame(width: 8, height: 8)
                                .padding(.top, 5)
                            Text(note)
                                .font(.subheadline)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        if note != notifications.last { Divider() }
                    }
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
        }
        .frame(width: 280)
    }
}

// Ensure this is OUTSIDE the NotificationDropdown struct
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    // Use .constant for previews of Binding variables
    NotificationDropdown(notifications: .constant([
        "James liked your photo",
        "New login from Chrome",
        "Your subscription was renewed"
    ]))
    .padding()
}
