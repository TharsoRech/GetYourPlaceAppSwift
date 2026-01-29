import SwiftUI

struct ResidenceDetailPopup: View {
    let residence: Residence
    @Binding var isPresented: Bool
    @State private var allImages: [UIImage] = []
    
    // Performance Optimization States
    @State private var isLoading = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring()) { isPresented = false }
                    }
                
                VStack(spacing: 0) {
                    imageHeaderSection
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 20) {
                            titleAndPriceSection
                            Divider().background(Color.white.opacity(0.2))
                            infoGridSection
                        }
                        .padding(24)
                        .redacted(reason: isLoading ? .placeholder : [])
                    }
                    
                    bottomActionBar
                }
                .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.8)
                .background(
                    ZStack {
                        BlurView(style: .systemThinMaterialDark)
                        Color(red: 0.05, green: 0.05, blue: 0.07).opacity(0.8)
                    }
                )
                .cornerRadius(32)
                .overlay(
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .overlay(alignment: .topTrailing) {
                    closeButton
                }
                .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea()
        .onAppear {
            loadDataSequentially()
        }
    }
    
    // MARK: - Subcomponents
    
    private var imageHeaderSection: some View {
        ZStack {
            if isLoading {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .shimmering()
            } else {
                ImageCarousel(images: allImages)
                    .transition(.opacity)
            }
        }
        .frame(height: 220)
        .clipped()
        .cornerRadius(28, corners: [.topLeft, .topRight]) // This uses the extension below
    }
    
    private var titleAndPriceSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text(residence.name)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                Label(residence.location, systemImage: "mappin.and.ellipse")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(residence.formattedPrice)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
        }
    }
    
    private var infoGridSection: some View {
        VStack(spacing: 15) {
            HStack {
                InfoItem(icon: "bed.double.fill", text: residence.formattedNumberOfBeds)
                Spacer()
                InfoItem(icon: "shower.fill", text: residence.formattedNumberOfbaths)
                Spacer()
                InfoItem(icon: "square.split.2x2.fill", text: "\(Int(residence.squareFootage)) sqft")
            }
            HStack {
                InfoItem(icon: "car.fill", text: residence.formattedNumberOfGarages)
                Spacer()
                InfoItem(icon: "door.left.hand.open", text: residence.formattedNumberOfRooms)
                Spacer()
                InfoItem(icon: "star.fill", text: String(format: "%.1f Rating", residence.rating))
            }
        }
    }
    
    private var bottomActionBar: some View {
        Button(action: { }) {
            Text("Contact Person")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 36)
        .disabled(isLoading)
    }

    private var closeButton: some View {
        Button(action: {
            withAnimation(.spring()) { isPresented = false }
        }) {
            Image(systemName: "xmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .padding(10)
                .background(Color.black.opacity(0.5))
                .clipShape(Circle())
        }
        .padding(16)
    }

    private func loadDataSequentially() {
        // Capture residence to avoid threading issues
        let residenceData = residence
        
        DispatchQueue.global(qos: .userInitiated).async {
            var base64Strings = [residenceData.mainImageBase64]
            base64Strings.append(contentsOf: residenceData.galleryImagesBase64)
            
            // Convert strings to UIImages HERE on the background thread
            let decodedImages = base64Strings.compactMap { base64String -> UIImage? in
                guard let data = Data(base64Encoded: base64String) else { return nil }
                return UIImage(data: data)
            }
            
            // Brief sleep to let the UI animation breathe
            usleep(200_000)
            
            DispatchQueue.main.async {
                // Now the Main Thread just receives finished objects
                self.allImages = decodedImages
                withAnimation(.easeOut(duration: 0.5)) {
                    self.isLoading = false
                }
            }
        }
    }
}

// MARK: - Supporting Views & Helpers

struct InfoItem: View {
    let icon: String
    let text: String
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon).foregroundColor(.gray).font(.system(size: 14))
            Text(text).foregroundColor(.white.opacity(0.8)).font(.system(size: 13, weight: .medium))
        }
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView { UIVisualEffectView(effect: UIBlurEffect(style: style)) }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

// This extension fixes the "Extra argument 'corners'" error
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview("Full Detail View") {
    // We create a modified mock with a sample base64 string to see the image logic in action
    let sampleResidence = Residence.mock
    // This is a tiny 1x1 transparent pixel base64 just to satisfy the decoder for the preview
    sampleResidence.mainImageBase64 = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg=="
    
    return ResidenceDetailPopup(
        residence: sampleResidence,
        isPresented: .constant(true)
    )
}
