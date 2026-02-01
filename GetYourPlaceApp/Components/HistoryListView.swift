import SwiftUI

struct HistoryListView: View {
    @Binding var profiles: [InterestedProfile]
    let filter: EngagementStatus
    
    var onChatTap: (InterestedProfile) -> Void
    
    var body: some View {
        ZStack {
            // Background color for the entire view
            Color(red: 0.1, green: 0.1, blue: 0.1).ignoresSafeArea()
            
            List {
                ForEach($profiles) { $profile in
                    // Only show profiles matching the current filter
                    if profile.status == filter {
                        HStack(spacing: 15) {
                            // Profile Info
                            VStack(alignment: .leading) {
                                Text(profile.name)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text(profile.residenceName)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            // 1. Chat Action (Only for Accepted status)
                            if filter == .accepted {
                                Button {
                                    onChatTap(profile)
                                } label: {
                                    Image(systemName: "message.fill")
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(Color.blue.opacity(0.2))
                                        .clipShape(Circle())
                                }
                                .buttonStyle(.plain)
                            }
                            
                            // 2. Status Logic: Show "Analyzing" vs "Reset"
                            if profile.status == .pending {
                                // Status indicator when pending
                                HStack(spacing: 5) {
                                    Image(systemName: " person.fill.viewfinder")
                                        .font(.subheadline)
                                    Text("Analyzing")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .fontWeight(.medium)
                                }
                                .foregroundColor(.blue)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                            } else {
                                // Show Reset button only if NOT pending
                                Button("Reset") {
                                    withAnimation(.spring()) {
                                        profile.status = .pending
                                    }
                                }
                                .buttonStyle(.bordered)
                                .tint(.orange)
                                .controlSize(.small)
                            }
                        }
                        .padding(.vertical, 4)
                        .listRowBackground(Color.clear)
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .navigationTitle(filter.rawValue.capitalized)
    }
}

// MARK: - Preview Logic
#Preview("History - Accepted List") {
    struct HistoryPreview: View {
        @State var mockProfiles = [
            InterestedProfile(name: "Jordan Lee", residenceName: "Beach House", imageUrl: "", status: .accepted),
            InterestedProfile(name: "Taylor Reed", residenceName: "Mountain Cabin", imageUrl: "", status: .accepted),
            InterestedProfile(name: "Casey Blair", residenceName: "City Apartment", imageUrl: "", status: .pending)
        ]
        
        var body: some View {
            NavigationStack {
                HistoryListView(profiles: $mockProfiles, filter: .accepted) { profile in
                    print("Preview: Chat opened for \(profile.name)")
                }
                .preferredColorScheme(.dark)
            }
        }
    }
    return HistoryPreview()
}
