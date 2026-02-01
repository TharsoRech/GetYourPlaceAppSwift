import SwiftUI

struct DiscoveryView: View {
    @Binding var profiles: [InterestedProfile]
    
    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.1, blue: 0.1).ignoresSafeArea()
            
            VStack {
                ZStack {
                    ForEach($profiles) { $profile in
                        if profile.status == .pending {
                            ProfileCardView(profile: $profile) { _ in }
                        }
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview("Discovery - Swipe Screen") {
    struct DiscoveryPreview: View {
        @State var mockProfiles = [
            InterestedProfile(name: "Alex Johnson", residenceName: "Sunset Villa", imageUrl: "", status: .pending),
            InterestedProfile(name: "Sarah Smith", residenceName: "Urban Loft", imageUrl: "", status: .pending)
        ]
        var body: some View {
            DiscoveryView(profiles: $mockProfiles)
        }
    }
    return DiscoveryPreview()
}
