import SwiftUI

struct ProfileCardView: View {
    @Binding var profile: InterestedProfile
    var onSwipe: (EngagementStatus) -> Void
    @State private var offset = CGSize.zero
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Card Body
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(colors: [.gray.opacity(0.3), .black], startPoint: .top, endPoint: .bottom))
                .overlay(
                    Text(profile.name.prefix(1))
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(.white.opacity(0.5))
                )
            
            // Info & Button
            VStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(profile.name).font(.title).bold()
                        .foregroundColor(.white)
                    Text("Interested in: \(profile.residenceName)").font(.subheadline).foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: { print("Navigate to detail for \(profile.name)") }) {
                    Text("See Profile")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                }
            }
            .padding(20)
            .background(LinearGradient(colors: [.clear, .black.opacity(0.8)], startPoint: .top, endPoint: .bottom))
        }
        .frame(width: 350, height: 500)
        .cornerRadius(20)
        .shadow(radius: 10)
        .offset(x: offset.width, y: offset.height * 0.4)
        .rotationEffect(.degrees(Double(offset.width / 40)))
        .gesture(
            DragGesture()
                .onChanged { offset = $0.translation }
                .onEnded { gesture in
                    if gesture.translation.width > 150 { completeSwipe(status: .accepted) }
                    else if gesture.translation.width < -150 { completeSwipe(status: .rejected) }
                    else { withAnimation(.spring()) { offset = .zero } }
                }
        )
    }
    
    private func completeSwipe(status: EngagementStatus) {
        withAnimation(.easeInOut) {
            offset.width = status == .accepted ? 500 : -500
            profile.status = status
            onSwipe(status)
        }
    }
}

#Preview("Interactive Card") {
    // We use a wrapper to handle the @Binding state in the preview
    struct PreviewWrapper: View {
        @State var mockProfile = InterestedProfile(
            name: "Alex Johnson",
            residenceName: "Sunset Villa",
            imageUrl: ""
        )
        
        var body: some View {
            VStack {
                ProfileCardView(profile: $mockProfile) { status in
                    print("Swiped: \(status)")
                }
                
                // Shows the status changing live in the preview
                Text("Status: \(mockProfile.status.rawValue)")
                    .font(.caption)
                    .padding(.top, 20)
            }
        }
    }
    
    return PreviewWrapper()
}
