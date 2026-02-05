import SwiftUI

struct ResidenceDetailPopup: View {
    @State var residence: Residence
    @Binding var isPresented: Bool
    @Environment(AuthManager.self) var authManager
    
    @State private var allImages: [UIImage] = []
    @State private var isLoading = true
    @State private var showingEditSheet = false
    
    // Custom Styled Popup State
    @State private var showingInterestPopup = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 1. Main Background Dimmer
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                    .onTapGesture {
                        // Prevent closing by mistake if the interest popup is active
                        if !showingInterestPopup {
                            withAnimation(.spring()) { isPresented = false }
                        }
                    }
                
                // 2. Main Detail Card
                VStack(spacing: 0) {
                    imageHeaderSection
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 20) {
                            titleAndPriceSection
                            Divider().background(Color.white.opacity(0.2))
                            infoGridSection
                            Divider().background(Color.white.opacity(0.2))
                            descriptionSection
                        }
                        .padding(24)
                        .redacted(reason: isLoading ? .placeholder : [])
                    }
                    
                    // Footer: Changes based on ownership
                    HStack(spacing: 12) {
                        if residence.isMine {
                            editButton
                        } else {
                            bottomActionBar
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 36)
                }
                .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.8)
                .background(
                    ZStack {
                        BlurView(style: .systemThinMaterialDark)
                        Color(red: 0.05, green: 0.05, blue: 0.07).opacity(0.85)
                    }
                )
                .cornerRadius(32)
                .overlay(RoundedRectangle(cornerRadius: 32).stroke(Color.white.opacity(0.15), lineWidth: 1))
                .overlay(alignment: .topTrailing) { closeButton }
                .shadow(color: .black.opacity(0.6), radius: 30, x: 0, y: 15)
                
                // 3. Custom Glass Interest Popup (The "Alert")
                if showingInterestPopup {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .transition(.opacity)
                    
                    customInterestAlert
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.8).combined(with: .opacity),
                            removal: .opacity
                        ))
                        .zIndex(2)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea()
        .onAppear { loadDataSequentially() }
        .sheet(isPresented: $showingEditSheet) {
            RegisterResidenceView(residenceToEdit: residence) { updatedResidence in
                self.residence = updatedResidence
                loadDataSequentially() // Refresh visuals with updated data
            }
        }
    }
    
    // MARK: - Custom UI Components
    
    private var customInterestAlert: some View {
        VStack(spacing: 25) {
            // Animated Header Icon
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 70, height: 70)
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 12) {
                Text("Request Sent")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                
                Text("A message will be sent to the owner about your interest. They will conduct an evaluation shortly.\n\nTrack your application in the **Interests** section of your profile.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.horizontal, 10)
            }
            
            Button(action: {
                withAnimation(.spring()) {
                    showingInterestPopup = false
                    isPresented = false // Fully close the detail view
                }
            }) {
                Text("Got it")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.white)
                    .cornerRadius(15)
            }
        }
        .padding(30)
        .frame(width: 320)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(red: 0.12, green: 0.12, blue: 0.15))
                .shadow(color: .black.opacity(0.5), radius: 40)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }

    private var bottomActionBar: some View {
        Button(action: {
            withAnimation(.spring()) { showingInterestPopup = true }
        }) {
            Text("Contact Person")
                .font(.headline).foregroundColor(.black)
                .frame(maxWidth: .infinity).frame(height: 55)
                .background(Color.white)
                .cornerRadius(16)
        }
        .disabled(isLoading)
    }
    
    private var editButton: some View {
        Button(action: { showingEditSheet = true }) {
            HStack {
                Image(systemName: "pencil.and.outline")
                Text("Edit My Property")
            }
            .font(.headline).foregroundColor(.black)
            .frame(maxWidth: .infinity).frame(height: 55)
            .background(Color.white)
            .cornerRadius(16)
        }
    }

    private var imageHeaderSection: some View {
        ZStack {
            if isLoading {
                Rectangle().fill(Color.white.opacity(0.1)).shimmering()
            } else {
                ImageCarousel(images: allImages).transition(.opacity)
            }
        }
        .frame(height: 220)
        .clipped()
        .cornerRadius(28, corners: [.topLeft, .topRight])
    }
    
    private var titleAndPriceSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text(residence.name).font(.title2.bold()).foregroundColor(.white)
                Label(residence.location, systemImage: "mappin.and.ellipse")
                    .font(.footnote).foregroundColor(.gray)
            }
            Spacer()
            Text(residence.formattedPrice)
                .font(.headline).foregroundColor(.white)
                .padding(.horizontal, 12).padding(.vertical, 8)
                .background(Color.white.opacity(0.1)).cornerRadius(10)
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

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("About this property").font(.headline).foregroundColor(.white)
            Text(residence.description.isEmpty ? "No description provided." : residence.description)
                .font(.subheadline).foregroundColor(.white.opacity(0.7)).lineSpacing(4)
        }
    }

    private var closeButton: some View {
        Button(action: { withAnimation(.spring()) { isPresented = false } }) {
            Image(systemName: "xmark").font(.system(size: 14, weight: .bold))
                .foregroundColor(.white).padding(10)
                .background(Color.black.opacity(0.5)).clipShape(Circle())
        }
        .padding(16)
    }

    private func loadDataSequentially() {
        self.isLoading = true
        let residenceData = residence
        DispatchQueue.global(qos: .userInitiated).async {
            var base64Strings = [residenceData.mainImageBase64]
            base64Strings.append(contentsOf: residenceData.galleryImagesBase64)
            
            let decodedImages = base64Strings.compactMap { str -> UIImage? in
                guard let data = Data(base64Encoded: str) else { return nil }
                return UIImage(data: data)
            }
            
            DispatchQueue.main.async {
                self.allImages = decodedImages
                withAnimation(.easeOut(duration: 0.5)) { self.isLoading = false }
            }
        }
    }
}

// MARK: - Reusable Styles & Helpers

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
    ).environment(AuthManager())
}
