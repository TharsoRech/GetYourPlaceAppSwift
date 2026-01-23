import SwiftUI

struct HeartButton: View {
    @Binding var isLiked: Bool
    // Parameter for the "liked" color
    var likedColor: Color
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isLiked.toggle()
            }
        }) {
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                // Use the parameter here
                .foregroundColor(isLiked ? likedColor : .gray)
                .padding(10)
        }
    }
}

// Preview
struct HeartButton_Previews: PreviewProvider {
    static var previews: some View {
        // We use a wrapper view so the @State can actually change
        PreviewWrapper()
    }
    
    struct PreviewWrapper: View {
        @State private var isLiked = false
        
        var body: some View {
            // Now passing both the binding and the color parameter
            HeartButton(isLiked: $isLiked, likedColor: .pink)
        }
    }
}

