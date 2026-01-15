import SwiftUI

struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .clear, location: phase - 0.2),
                            .init(color: .white.opacity(0.2), location: phase),
                            .init(color: .clear, location: phase + 0.2)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .offset(x: -geo.size.width + (geo.size.width * 2 * phase))
                }
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmering() -> some View {
        self.modifier(ShimmerEffect())
    }
}

#Preview("Skeleton Shimmer Demo") {
    VStack(spacing: 24) {
        // 1. Circle Skeleton (Like a profile picture)
        HStack {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 60)
                .shimmering()
            
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 150, height: 20)
                    .shimmering()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 15)
                    .shimmering()
            }
            Spacer()
        }
        
        // 2. Large Card Skeleton (Like ResidenceView)
        VStack(alignment: .leading, spacing: 12) {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 200)
                .shimmering()
            
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 200, height: 25)
                .shimmering()
        }
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(red: 0.1, green: 0.1, blue: 0.1)) // Dark mode background
    .preferredColorScheme(.dark)
}
