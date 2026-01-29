import SwiftUI

struct ResidenceDetailPopup: View {
    let residence: Residence
    @Binding var isPresented: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 1. FULL SCREEN DIMMED BACKGROUND
                // This makes the user realize they are in a modal layer
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring()) { isPresented = false }
                    }
                
                // 2. Main Popup Container
                VStack(spacing: 0) {
                    imageHeaderSection
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 20) {
                            titleAndPriceSection
                            
                            Divider().background(Color.white.opacity(0.2))
                            
                            infoGridSection
                            
                            gallerySection
                        }
                        .padding(24)
                    }
                    
                    bottomActionBar
                }
                // Setting width to 90% of the screen and height to 80% to ensure it fits all devices
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
    }
    
    // --- RESTORED ORIGINAL STYLES ---

    private var imageHeaderSection: some View {
        ZStack(alignment: .bottomLeading) {
            if let uiImage = decodeBase64(residence.mainImageBase64) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .overlay(Image(systemName: "house.fill").foregroundColor(.white.opacity(0.2)))
            }
        }
        .frame(height: 220)
        .clipped()
        .cornerRadius(28, corners: [.topLeft, .topRight])
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
    
    private var gallerySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Gallery")
                .font(.headline)
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(residence.galleryImagesBase64, id: \.self) { base64 in
                        if let uiImage = decodeBase64(base64) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .cornerRadius(12)
                        }
                    }
                }
            }
        }
    }
    
    private var bottomActionBar: some View {
        Button(action: { /* Booking or Contact Logic */ }) {
            Text("Contact Person")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(Color.white.opacity(0.1)) // Restored original color
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
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
    
    struct BlurView: UIViewRepresentable {
        var style: UIBlurEffect.Style
        func makeUIView(context: Context) -> UIVisualEffectView {
            UIVisualEffectView(effect: UIBlurEffect(style: style))
        }
        func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
    }
    
    private func decodeBase64(_ string: String) -> UIImage? {
        guard let data = Data(base64Encoded: string) else { return nil }
        return UIImage(data: data)
    }
}

// RESTORED ORIGINAL INFO ITEM & SHAPES
struct InfoItem: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .font(.system(size: 14))
            Text(text)
                .foregroundColor(.white.opacity(0.8))
                .font(.system(size: 13, weight: .medium))
        }
    }
}

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
