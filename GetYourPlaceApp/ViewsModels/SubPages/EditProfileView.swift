import SwiftUI

struct EditProfileView: View {
    @Bindable var profile: UserProfile
    
    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.1, blue: 0.1)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                profileImageHeader
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        CustomInputField(label: "Name", text: $profile.name.toUnwrapped)
                        CustomDescriptionField(label: "About", text: $profile.bio.toUnwrapped)
                        CustomInputField(label: "Email", text: $profile.email.toUnwrapped)
                        CustomInputField(label: "Password", text: $profile.password.toUnwrapped, isSecure: true)
                        CustomDropdownField(label: "Date of Birth", value: $profile.dob.toUnwrapped)
                        CustomDropdownField(label: "Country/Region", value: $profile.country.toUnwrapped)
                    }
                    .padding(.horizontal, 24)
                }
                
                saveButton
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Edit Profile").font(.headline).foregroundColor(.white)
            }
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
        .padding(.bottom,84)
    }
    
    private var profileImageHeader: some View {
        ZStack(alignment: .bottomTrailing) {
            Circle()
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                .frame(width: 160, height: 160)
                .overlay(
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 140)
                        .foregroundColor(.gray.opacity(0.6))
                        .clipShape(Circle())
                )
            
            Circle()
                .fill(Color.gray.opacity(0.9))
                .frame(width: 38, height: 38)
                .overlay(Image(systemName: "camera.fill").foregroundColor(.white).font(.system(size: 14)))
                .offset(x: -8, y: -5)
        }
        .padding(.top, 10)
    }
    
    private var saveButton: some View {
        Button(action: { print("Saving: \(String(describing: profile.name))") }) {
            Text("Save changes")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(Color.black)
                .cornerRadius(12)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 20)
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
            .tint(.white)
    }
}
