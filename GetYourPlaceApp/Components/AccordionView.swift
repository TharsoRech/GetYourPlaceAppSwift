import SwiftUI

struct AccordionView<Content: View>: View {
    @Binding var text: String
    @State var isAccordionExpanded: Bool = false
    
    let maxHeight: CGFloat = 500
    let content: () -> Content

    var body: some View {
        VStack {
            DisclosureGroup(isExpanded: $isAccordionExpanded) {
                ScrollView {
                         content()
                       }
                       .padding(.top,16)
                       .frame(maxHeight: maxHeight)
            } label: {
                Text(text)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .accentColor(.white)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.black)
            .cornerRadius(8)
        }
        .padding(.horizontal, 8)
        .padding(.top, 16)
    }
}

#Preview {
    AccordionView(text: .constant("Published Properties")) {
        ResidenceListView(
            // Wrap the entire array in .constant()
            residences: .constant([
                Residence(
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
                    rating: 4.0,
                    createdAt: Date().addingTimeInterval(-10000),
                    mainImageBase64: "house1".asAssetBase64,
                    galleryImagesBase64: ["house1".asAssetBase64, "house1".asAssetBase64],
                    favorite: false
                ),
                Residence(
                    name: "Skyline Apartment",
                    address: "888 Central Ave",
                    location: "New York, NY",
                    type: "House",
                    price: 950000.0,
                    numberOfRooms: 3,
                    numberOfBeds: 1,
                    baths: 1,
                    squareFootage: 850.0,
                    hasGarage: false,
                    numberOfGarages: 1,
                    rating: 4.0,
                    createdAt: Date().addingTimeInterval(-20000),
                    mainImageBase64: "house2".asAssetBase64,
                    galleryImagesBase64: ["house2".asAssetBase64],
                    favorite: false
                ),
                Residence(
                    name: "Cozy Cottage",
                    address: "42 Forest Road",
                    location: "Aspen, CO",
                    type: "Apartment",
                    price: 1200000.0,
                    numberOfRooms: 5,
                    numberOfBeds: 3,
                    baths: 2,
                    squareFootage: 1800.0,
                    hasGarage: true,
                    numberOfGarages: 1,
                    rating: 4.0,
                    createdAt: Date(),
                    mainImageBase64: "house3".asAssetBase64,
                    galleryImagesBase64: [],
                    favorite: false
                )
            ]),
            isLoading: false,
            isFetchingMore: false,
            // You can also pass the scrollable flag if needed
            isScrollable: false,
            onLoadMore: { },
            onSelect: { _ in }
        )
    }
}
