import SwiftUI

struct ConversationRowSkeleton: View {
    var body: some View {
        HStack(spacing: 15) {
            // Profile Picture Circle
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 55, height: 55)
                .shimmering()
            
            VStack(alignment: .leading, spacing: 8) {
                // Name
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 120, height: 18)
                    .shimmering()
                
                // Last Message snippet
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(maxWidth: .infinity)
                    .frame(height: 14)
                    .shimmering()
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ConversationRowSkeleton()
}
