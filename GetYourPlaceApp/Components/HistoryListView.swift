import SwiftUI

struct HistoryListView: View {
    @Binding var profiles: [InterestedProfile]
    let filter: EngagementStatus
    
    var onChatTap: (InterestedProfile) -> Void
    
    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.1, blue: 0.1).ignoresSafeArea()
            List {
                ForEach($profiles) { $profile in
                    if profile.status == filter {
                        HStack(spacing: 15) {
                            VStack(alignment: .leading) {
                                Text(profile.name).font(.headline)
                                Text(profile.residenceName).font(.caption).foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            if filter == .accepted {
                                // Use a Button instead of NavigationLink to trigger the parameter
                                Button {
                                    onChatTap(profile)
                                } label: {
                                    Image(systemName: "message.fill")
                                        .foregroundColor(.white)
                                        .padding(8)
                                }
                                .buttonStyle(.plain)
                            }
                            
                            Button("Reset") {
                                withAnimation { profile.status = .pending }
                            }
                            .buttonStyle(.bordered)
                            .tint(.orange)
                        }.listRowBackground(Color.clear)
                    }
                }
            }
            .navigationTitle(filter.rawValue)
        }
        .scrollContentBackground(.hidden)
                .navigationTitle(filter.rawValue)
    }
}

#Preview("History - Accepted List") {
    struct HistoryPreview: View {
        @State var mockProfiles = [
            InterestedProfile(name: "Jordan Lee", residenceName: "Beach House", imageUrl: "", status: .accepted),
            InterestedProfile(name: "Taylor Reed", residenceName: "Mountain Cabin", imageUrl:  "", status: .accepted)
        ]
        
        var body: some View {
            HistoryListView(profiles: $mockProfiles, filter: .accepted) { profile in
                // This satisfies the new onChatTap parameter
                print("Preview: Chat opened for \(profile.name)")
            }
            .preferredColorScheme(.dark)
        }
    }
    return HistoryPreview()
}
