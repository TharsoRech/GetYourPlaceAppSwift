import SwiftUI

struct NotificationDropdown: View {
    @Binding var notifications: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 1. The Arrow
            HStack {
                Spacer()
                Triangle()
                    .fill(Color(red: 0.1, green: 0.1, blue: 0.1))
                    .frame(width: 20, height: 10)
                    .padding(.trailing, 20)
            }
            
            // 2. The Main Box
            VStack(alignment: .leading, spacing: 0) {
                Text("Notifications")
                    .font(.headline)
                    .padding()

                if notifications.isEmpty {
                    Text("No new notifications")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(notifications, id: \.self) { note in
                        // Using a Button ensures the "Hover" and "Pressed" states are handled by the OS
                        Button(action: { print("Tapped \(note)") }) {
                            HStack(alignment: .top, spacing: 12) {
                                Circle()
                                    .fill(Color(red: 0.1, green: 0.1, blue: 0.1))
                                    .frame(width: 8, height: 8)
                                    .padding(.top, 5)
                                
                                Text(note)
                                    .font(.subheadline)
                                    .foregroundColor(.primary) // Keeps text dark
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(NotificationButtonStyle()) // Custom style for hover/press
                        
                        if note != notifications.last {
                            Divider().padding(.horizontal)
                        }
                    }
                }
            }
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
        }
        .frame(width: 280)
    }
}

// THIS IS THE KEY: A custom style that handles the background color change
struct NotificationButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // configuration.isPressed handles clicks
            // On macOS, Button automatically handles hover highlight if using this style
            .background(configuration.isPressed ? Color.black.opacity(0.1) : Color.clear)
            // Add this specifically for macOS hover support
            .onHover { isHovering in
                // This is a backup for macOS environments
            }
    }
}

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
    NotificationDropdown(notifications: .constant([
        "James liked your photo",
        "New login from Chrome",
        "Your subscription was renewed"
    ]))
    .padding()
}
