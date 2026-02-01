import SwiftUI

struct MatchsResidencesSkeleton: View {
    var body: some View {
        VStack(spacing: 24) {
            // Profile Header Shimmer
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
            
            // Main Content Card Shimmer
            VStack(alignment: .leading, spacing: 12) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 300) // Adjusted for Discovery look
                    .shimmering()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 200, height: 25)
                    .shimmering()
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    MatchsResidencesSkeleton()
}
