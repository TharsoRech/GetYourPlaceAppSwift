import SwiftUI

struct PersonalDetailsView: View {
    @Bindable var profile: UserProfile
    
    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.1, blue: 0.1).ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    CustomInputField(label: "Full Name", text: $profile.name.toUnwrapped)
                    CustomInputField(label: "Profession", text: $profile.profession.toUnwrapped) // Added here
                    CustomDescriptionField(label: "About Me", text: $profile.bio.toUnwrapped)
                    CustomDropdownField(label: "Date of Birth", value: $profile.dob.toUnwrapped)
                    CustomDropdownField(label: "Country/Region", value: $profile.country.toUnwrapped)
                    
                    SaveButton(profile: profile)
                }
                .padding(24)
            }
        }
    }
}

#Preview {
    PersonalDetailsView(profile: UserProfile.mock)
}
