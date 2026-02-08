import SwiftUI

struct ResidenceDetailPopup: View {
    @State var residence: Residence
    @Binding var isPresented: Bool
    @Environment(AuthManager.self) var authManager
    
    @State private var allImages: [UIImage] = []
    @State private var isLoading = true
    @State private var showingEditSheet = false
    @State private var showingInterestPopup = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                    .onTapGesture {
                        if !showingInterestPopup {
                            withAnimation(.spring()) { isPresented = false }
                        }
                    }
                
                VStack(spacing: 0) {
                    imageHeaderSection
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 20) {
                            titleAndPriceSection
                            
                            // 1. Rating Badge
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill").foregroundColor(.yellow)
                                Text(String(format: "%.1f", residence.rating)).fontWeight(.bold).foregroundColor(.white)
                                Text("(Reviews)").foregroundColor(.white)
                            }
                            .font(.caption)
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(Color.white.opacity(0.1)).cornerRadius(6)
                            
                            Divider().background(Color.white.opacity(0.2))
                            
                            // 2. Info Grid (Including Pets)
                            VStack(spacing: 18) {
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
                                    InfoItem(icon: "pawprint.fill", text: residence.petsStatus)
                                }
                            }
                            
                            Divider().background(Color.white.opacity(0.2))
                            
                            descriptionSection
                        }
                        .padding(24)
                        .redacted(reason: isLoading ? .placeholder : [])
                    }
                    
                    footerActions
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
                
                if showingInterestPopup {
                    interestAlertOverlay
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea()
        .onAppear { loadDataSequentially() }
        .sheet(isPresented: $showingEditSheet) {
            RegisterResidenceView(residenceToEdit: residence) { updated in
                self.residence = updated
                loadDataSequentially()
            }
        }
    }
    
    // MARK: - Components
    
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
    
    private var footerActions: some View {
        HStack(spacing: 12) {
            if residence.isMine {
                Button(action: { showingEditSheet = true }) {
                    Label("Edit My Property", systemImage: "pencil").frame(maxWidth: .infinity).frame(height: 55)
                        .background(Color.white).foregroundColor(.black).cornerRadius(16).bold()
                }
            } else {
                Button(action: { withAnimation(.spring()) { showingInterestPopup = true } }) {
                    Text("Contact Person").font(.headline).foregroundColor(.black)
                        .frame(maxWidth: .infinity).frame(height: 55)
                        .background(Color.white).cornerRadius(16)
                }
            }
        }
        .padding(.horizontal, 24).padding(.bottom, 36)
    }

    private var imageHeaderSection: some View {
        ZStack {
            if isLoading {
                Rectangle().fill(Color.white.opacity(0.1))
            } else if let uiImage = Data(base64Encoded: residence.mainImageBase64).flatMap(UIImage.init) {
                Image(uiImage: uiImage).resizable().scaledToFill()
            } else {
                Color.gray.opacity(0.3)
            }
        }
        .frame(height: 220).clipped().cornerRadius(28, corners: [.topLeft, .topRight])
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
        }.padding(16)
    }

    private var interestAlertOverlay: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
            VStack(spacing: 25) {
                Image(systemName: "paperplane.fill").font(.largeTitle).foregroundColor(.white)
                Text("Request Sent").font(.title3.bold()).foregroundColor(.white)
                Text("A message will be sent to the owner about your interest. They will conduct an evaluation shortly.\n\nTrack your application in the **Interests** section of your profile.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.horizontal, 10)
                Button("Got it") { withAnimation { showingInterestPopup = false; isPresented = false } }
                    .frame(maxWidth: .infinity).frame(height: 50).background(Color.white).foregroundColor(.black).cornerRadius(15).bold()
            }
            .padding(30).frame(width: 320).background(Color(red: 0.12, green: 0.12, blue: 0.15)).cornerRadius(30)
        }
    }

    private func loadDataSequentially() {
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation { self.isLoading = false }
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
