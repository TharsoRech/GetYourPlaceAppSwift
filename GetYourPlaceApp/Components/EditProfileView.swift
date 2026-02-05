import SwiftUI

struct EditProfileView: View {
    @Bindable var profile: UserProfile
    @Environment(AuthManager.self) private var authManager
    
    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.1, blue: 0.1)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        CustomInputField(label: "Email", text: $profile.email.toUnwrapped)
                        CustomInputField(label: "Password", text: $profile.password.toUnwrapped, isSecure: true)
                        
                        logoutButton
                    }
                    .padding(.horizontal, 24)
                }
                
                SaveButton(profile: profile)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Edit Profile").font(.headline).foregroundColor(.white)
            }
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
        .padding(.bottom, 84)
    }
    
    private var logoutButton: some View {
        VStack{
            Button(action: {
                        authManager.logout()
                    }) {
                        Text("Log Out")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color.black)
                            .cornerRadius(12)
                    }
            
            Button(action: {
                authManager.logout()
                    }) {
                        Text("Remove Account")
                            .font(.headline)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color.black)
                            .cornerRadius(12)
                    }
        }
    }
}

#Preview("Edit Profile Full View") {
    @Previewable @State var user = UserProfile(
        name: "Melissa Peters",
        email: "melpeters@gmail.com",
        password: "password123",
        dob: "23/05/1995",
        country: "Nigeria",
        bio: "I am a mobile developer and UI enthusiast."
    )
    
    return NavigationStack {
        EditProfileView(profile: user)
            .tint(.white).environment(AuthManager())
    }
}
