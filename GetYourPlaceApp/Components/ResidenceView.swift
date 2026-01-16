import SwiftUI

struct ResidenceView: View {
    var residence: Residence
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // 1. Check for the image
                if let mainImg = residence.mainImageBase64.toSwiftUIImage() {
                    mainImg
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                        .clipped()
                        .overlay(alignment: .top) {
                            HStack {
                                Text(residence.type)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .foregroundColor(.black)
                                    .font(.system(size: 18, weight: .regular, design: .default))
                                    .background(
                                        RoundedRectangle(cornerRadius: 32)
                                            .fill(Color.white.opacity(0.9)) //
                                    )
                                Spacer()
                                HeartButton()
                                    .padding(10)
                                    .background(Circle().fill(Color.white.opacity(0.9)))
                            }
                            .padding()
                        }
                    HStack {
                            Text(residence.name)
                                .font(.system(size: 20, weight: .regular, design: .default))
                            Spacer()
                        Text(residence.formattedPrice)
                            .font(.system(size: 22, weight: .regular, design: .default))
                        }
                        .padding(.top, 8)
                        .padding(.horizontal)
                        .padding(.bottom, 16)
                    HStack {
                        Text(residence.formattedLocation)
                            .font(.system(size: 16, weight: .regular, design: .default))
                        Spacer()
                    }.padding(.top, 0)
                        .padding(.horizontal)
                        .padding(.bottom, 16)
                    HStack {
                        ResidenceCharacteristics(text: residence.formattedNumberOfBeds, iconName: "bed.double.fill")
                        ResidenceCharacteristics(text: residence.formattedNumberOfbaths, iconName: "bathtub.fill")
                        ResidenceCharacteristics(text: residence.formattedNumberOfGarages, iconName: "door.garage.closed")
                        Spacer()
                    }.padding(.top, 0)
                        .padding(.bottom, 16)
                    
                }
            }
            .background(Color.white)
            .cornerRadius(24)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            .padding()
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
            mainImageBase64: "house1".asAssetBase64,
            galleryImagesBase64: ["house1".asAssetBase64, "house1".asAssetBase64]
        )
        
        // Pass the mock data into your SwiftUI View
        ResidenceView(residence: mockResidence)
}
