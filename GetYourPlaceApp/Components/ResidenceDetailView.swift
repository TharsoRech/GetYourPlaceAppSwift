import SwiftUI

struct ResidenceDetailView: View {
    var residence: Residence
        
        var body: some View {
            ScrollView {
                VStack {
                    // Display Main Image
                    if let mainImg = residence.mainImageBase64.toSwiftUIImage() {
                        mainImg
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250)
                            .clipped()
                    }

                    // Display Gallery
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(residence.galleryImagesBase64, id: \.self) { base64String in
                                if let img = base64String.toSwiftUIImage() {
                                    img
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
            }
        }
}

#Preview {
    let placeholderBase64 = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII="
        
        let mockResidence = Residence(
            name: "Modern Villa",
            address: "123 luxury Way",
            location: "Los Angeles, CA",
            type: "House",
            price: 2500000.0,
            numberOfRooms: 8,
            numberOfBeds: 4,
            baths: 3,
            squareFootage: 3500.0,
            hasGarage: true,
            mainImageBase64: placeholderBase64,
            galleryImagesBase64: [placeholderBase64, placeholderBase64]
        )
        
        // Pass the mock data into your SwiftUI View
        ResidenceDetailView(residence: mockResidence)
}
