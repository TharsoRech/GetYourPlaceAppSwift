import SwiftUI

struct SaveButton: View {
    // We use @Bindable here so the view can react to/edit the profile
    @Bindable var profile: UserProfile
    
    var body: some View {
        Button(action: {
            print("Saving: \(String(describing: profile.name))")
        }) {
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

#Preview {
    SaveButton(profile: UserProfile.mock)
        .background(Color.gray)
}
