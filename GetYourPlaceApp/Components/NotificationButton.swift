import SwiftUI

struct NotificationButton: View {
    // FIX: Remove the default value [].
    // This now expects the parent view to pass the array.
    @Binding var notifications: [String]
    
    @State private var showList = false
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    showList.toggle()
                }
            }) {
                ZStack(alignment: .topTrailing) {
                    Circle()
                        .fill(Color(white: 0.2))
                        .frame(width: 45, height: 45)
                        .overlay(
                            Image(systemName: "bell.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        )
                    
                    if !notifications.isEmpty {
                        Text("\(notifications.count)")
                            .font(.caption2).bold()
                            .foregroundColor(.white)
                            .frame(width: 18, height: 18)
                            .background(Color.red)
                            .clipShape(Circle())
                            .offset(x: 4, y: -4)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if showList {
                // We pass the binding further down to the dropdown
                NotificationDropdown(notifications: $notifications)
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.1, anchor: .topTrailing).combined(with: .opacity),
                        removal: .opacity.combined(with: .scale(scale: 0.1, anchor: .topTrailing))
                    ))
                    .zIndex(1)
            }
        }
    }
}

#Preview {
    // In Preview, we use .constant to simulate the parameter
    NotificationButton(notifications: .constant([
        "James liked your photo",
        "New login from Chrome"
    ]))
}
