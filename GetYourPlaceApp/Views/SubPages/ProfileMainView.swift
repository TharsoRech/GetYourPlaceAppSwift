import SwiftUI

struct ProfileMainView: View {
    @Bindable var profile: UserProfile
    @Environment(AuthManager.self) private var authManager
    
    // Track the selected tab
    @State private var selectedTab: ProfileTab = .account
    
    
    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.1, blue: 0.1).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Fixed Header
                ProfileImageHeader()
                    .padding(.top, 10)
                
                // 2. Custom Tab Bar (Right below the image)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 25) {
                        ForEach(ProfileTab.allCases, id: \.self) { tab in
                            Button(action: { selectedTab = tab }) {
                                VStack(spacing: 8) {
                                    Label(tab.rawValue, systemImage: tab.icon)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(selectedTab == tab ? .white : .gray)
                                    
                                    // Underline for active tab
                                    Rectangle()
                                        .fill(selectedTab == tab ? Color.white : Color.clear)
                                        .frame(height: 2)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 25)
                }
                .padding(.vertical, 15)
                
                Divider().background(Color.white.opacity(0.1))
                
                // 3. Dynamic Content Area
                Group {
                    switch selectedTab {
                    case .account:
                        EditProfileView(profile: profile)
                    case .personal:
                        PersonalDetailsView(profile: profile)
                    case .rentals:
                        RentalHistoryView()
                    case .reviews:
                        ReviewsView()
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .bottom))) // Smooth switching
                
                Spacer()
            }
        }
        .animation(.spring(), value: selectedTab)
    }
}
#Preview {
    ProfileMainView(profile: UserProfile.mock).environment(AuthManager())
}
