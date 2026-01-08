import SwiftUI

struct HeartButton: View {
    @State private var isLiked: Bool = false
    
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
                .foregroundColor(isLiked ? .red : .gray)
                .scaleEffect(isLiked ? 1.2 : 1.0)
        }
    }
}

// Preview
struct HeartButton_Previews: PreviewProvider {
    static var previews: some View {
        HeartButton()
    }
}
