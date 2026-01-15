import SwiftUI

struct MenuItem: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(label)
                    .padding(.horizontal,6)
                    .foregroundColor(isSelected ? .white : .black)
                    .font(.system(size: 10, weight: .medium))
                    .lineLimit(1) // Prevents text from wrapping and changing height
                    .minimumScaleFactor(0.8) // Shrinks text slightly if it's too long
            }
            .foregroundColor(isSelected ? .white : .black)
            // 1. This ensures every button takes up equal horizontal space
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .fill(isSelected ? Color.black : Color.white.opacity(0.9))
            )
        }
        // 2. Add small padding here to create gaps between the rounded shapes
        .padding(.horizontal, 4)
    }
}

#Preview("Full Menu Bar") {
    ZStack {
        Color.gray.opacity(0.2).ignoresSafeArea() // Background to see the white buttons
        
        HStack(spacing: 0) { // Spacing 0 is important for equal distribution
            MenuItem(icon: "house.fill", label: "Home", isSelected: true) {}
            MenuItem(icon: "key.fill", label: "My Rents", isSelected: false) {}
            MenuItem(icon: "heart.fill", label: "Saved", isSelected: false) {}
            MenuItem(icon: "bubble.left.fill", label: "Chat", isSelected: false) {}
            MenuItem(icon: "person.circle.fill", label: "Profile", isSelected: false) {}
        }
        .padding(.horizontal, 10)
    }
}
