import SwiftUI

struct ImageCarousel: View {
    let images: [String]
    
    var body: some View {
        TabView {
            ForEach(images, id: \.self) { base64 in
                if let uiImage = decodeBase64(base64) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                } else {
                    placeholderView
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
    }
    
    private var placeholderView: some View {
        Rectangle()
            .fill(Color.white.opacity(0.1))
            .overlay(
                Image(systemName: "house.fill")
                    .foregroundColor(.white.opacity(0.2))
                    .font(.largeTitle)
            )
    }
    
    private func decodeBase64(_ string: String) -> UIImage? {
        guard let data = Data(base64Encoded: string) else { return nil }
        return UIImage(data: data)
    }
}

#Preview("Image Carousel") {
    // Creating dummy Base64 strings for testing swiping
    let redPixel = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg=="
    let bluePixel = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60eOFQAAAABJRU5ErkJggg=="
    let greenPixel = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+P+/HgAFhAJ/wlseKgAAAABJRU5ErkJggg=="
    
    ZStack {
        Color.black.ignoresSafeArea()
        
        ImageCarousel(images: [redPixel, bluePixel, greenPixel])
            .frame(height: 250)
            .cornerRadius(20)
            .padding()
    }
}
