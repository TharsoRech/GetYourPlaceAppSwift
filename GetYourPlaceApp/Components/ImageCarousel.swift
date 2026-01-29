import SwiftUI

struct ImageCarousel: View {
    let images: [UIImage]
    
    var body: some View {
        TabView {
            if images.isEmpty {
                placeholderView
            } else {
                ForEach(0..<images.count, id: \.self) { index in
                    Image(uiImage: images[index])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .clipped() // Ensures image doesn't bleed out of bounds
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
}

#Preview("Image Carousel") {
    let redPixel = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg=="
    let bluePixel = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60eOFQAAAABJRU5ErkJggg=="
    let greenPixel = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+P+/HgAFhAJ/wlseKgAAAABJRU5ErkJggg=="
    
    let mockStrings = [redPixel, bluePixel, greenPixel]
    
    // Explicitly declaring [UIImage] solves the inference error
    let mockImages: [UIImage] = mockStrings.compactMap { str in
        guard let data = Data(base64Encoded: str) else { return nil }
        return UIImage(data: data)
    }
    
    return ZStack {
        Color.black.ignoresSafeArea()
        
        ImageCarousel(images: mockImages)
            .frame(height: 250)
            .cornerRadius(20)
            .padding()
    }
}
