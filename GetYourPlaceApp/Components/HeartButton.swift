import SwiftUI

import SwiftUI

struct HeartButton: View {
    @Binding var isLiked: Bool
    @Environment(AuthManager.self) private var auth
    var likedColor: Color
    
    var body: some View {
        // Only show the button if authenticated
        if auth.isAuthenticated {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isLiked.toggle()
                }
            }) {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(isLiked ? likedColor : .gray)
                    // Added a little extra punch to the animation
                    .scaleEffect(isLiked ? 1.2 : 1.0)
                    .padding(10)
            }
        }
    }
}

// Preview
struct HeartButton_Previews: PreviewProvider {
    static var previews: some View {
        // We use a wrapper view so the @State can actually change
        PreviewWrapper().environment(AuthManager())
    }
    
    struct PreviewWrapper: View {
        @State private var isLiked = false
        
        var body: some View {
            // Now passing both the binding and the color parameter
            HeartButton(isLiked: $isLiked, likedColor: .pink).environment(AuthManager())
        }
    }
}

