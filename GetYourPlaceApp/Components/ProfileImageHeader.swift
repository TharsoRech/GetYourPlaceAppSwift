import SwiftUI
import PhotosUI

struct ProfileImageHeader: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var profileImage: Image? = nil

    var body: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
            ZStack(alignment: .bottomTrailing) {
                // Main Circle Container
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    .frame(width: 160, height: 160)
                    .overlay(
                        Group {
                            if let profileImage {
                                profileImage
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .foregroundColor(.gray.opacity(0.6))
                            }
                        }
                        .frame(width: 140, height: 140)
                        .clipShape(Circle())
                    )
                
                // Camera Icon Overlay
                Circle()
                    .fill(Color.gray.opacity(0.9))
                    .frame(width: 38, height: 38)
                    .overlay(
                        Image(systemName: "camera.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                    )
                    .offset(x: -8, y: -5)
            }
        }
        // FIX: Added the two-parameter closure (oldValue, newValue)
        .onChange(of: selectedItem) { _, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    profileImage = Image(uiImage: uiImage)
                }
            }
        }
        .padding(.top, 10)
    }
}

#Preview {
    ProfileImageHeader()
}
