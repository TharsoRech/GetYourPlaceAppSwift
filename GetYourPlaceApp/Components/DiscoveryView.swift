import SwiftUI

struct DiscoveryView: View {
    @Binding var profiles: [InterestedProfile]
    @State private var selectedProfile: UserProfile?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.1, green: 0.1, blue: 0.1)
                    .ignoresSafeArea()
                
                VStack {
                    ZStack {
                        ForEach($profiles) { $profile in
                            if profile.status == .pending {
                                ProfileCardView(profile: $profile) { status in
                                    handleCardAction(status, for: profile)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $selectedProfile) { profile in
                PublicProfileView(profile: profile)
            }
        }
    }
    
    private func handleCardAction(_ action: EngagementStatus, for profile: InterestedProfile) {
        if action == .seeProfile {
            self.selectedProfile = UserProfile(
                id: profile.id,
                name: profile.name,
                country: "Location Pending",
                bio: "Interested in: \(profile.residenceName)",
                role: .owner
            )
        } else if action == .accepted {
            print("\(profile.name) was accepted")
        } else if action == .rejected {
            print("\(profile.name) was rejected")
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
