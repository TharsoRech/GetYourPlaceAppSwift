import SwiftUI

struct ResidenceView: View {
    var residence: Residence
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) { // Set to leading for better text alignment
                // 1. Image and Overlay using ZStack
                if let mainImg = residence.mainImageBase64.toSwiftUIImage() {
                    ZStack(alignment: .top) {
                        mainImg
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250)
                        // This next line is critical:
                                                .frame(minWidth: 0, maxWidth: .infinity)
                            .clipped()
                        
                        // Floating Controls
                        HStack {
                            Text(residence.type)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .foregroundColor(.black)
                                .font(.system(size: 18))
                                .background(
                                    RoundedRectangle(cornerRadius: 32)
                                        .fill(Color.white.opacity(0.9))
                                )
                            
                            Spacer()
                            
                            HeartButton()
                                .padding(10)
                                .background(Circle().fill(Color.white.opacity(0.9)))
                        }
                        .padding()
                    }
                }
                
                // 2. Info Content
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(residence.name)
                            .font(.system(size: 20, weight: .regular))
                        Spacer()
                        Text(residence.formattedPrice)
                            .font(.system(size: 22, weight: .regular))
                    }
                    
                    Text(residence.formattedLocation)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.secondary)
                    
                }
                .padding(16)
                
                HStack(spacing: 0) {
                    ResidenceCharacteristics(text: residence.formattedNumberOfBeds, iconName: "bed.double.fill")
                    ResidenceCharacteristics(text: residence.formattedNumberOfbaths, iconName: "bathtub.fill")
                    ResidenceCharacteristics(text: residence.formattedNumberOfGarages, iconName: "door.garage.closed")
                }
                .padding(.vertical,12)
            }
            .background(Color.white)
            .cornerRadius(24)
            .foregroundColor(.black)
            .padding(.vertical,8)
            .padding(.horizontal,4)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
    }
}

#Preview {
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
            numberOfGarages: 1,
            rating:5.0,
            createdAt: Date(),
            mainImageBase64: "house1".asAssetBase64,
            galleryImagesBase64: ["house1".asAssetBase64, "house1".asAssetBase64]
        )
        
        // Pass the mock data into your SwiftUI View
        ResidenceView(residence: mockResidence)
}
