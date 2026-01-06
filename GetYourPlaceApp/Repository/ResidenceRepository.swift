class ResidenceRepository: ResidenceRepositoryProtocol {
    func getRecentResidences() async -> [Residence] {
            // Simulating 1-second network delay
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            
            // Placeholder Base64 (A tiny transparent pixel to avoid empty strings)
            let placeholderBase64 = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII="
            
            return [
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
                    mainImageBase64: placeholderBase64,
                    galleryImagesBase64: [placeholderBase64, placeholderBase64]
                ),
                Residence(
                    name: "Skyline Apartment",
                    address: "888 Central Ave",
                    location: "New York, NY",
                    type: "Apartment",
                    price: 950000.0,
                    numberOfRooms: 3,
                    numberOfBeds: 1,
                    baths: 1,
                    squareFootage: 850.0,
                    hasGarage: false,
                    mainImageBase64: placeholderBase64,
                    galleryImagesBase64: [placeholderBase64]
                ),
                Residence(
                    name: "Cozy Cottage",
                    address: "42 Forest Road",
                    location: "Aspen, CO",
                    type: "House",
                    price: 1200000.0,
                    numberOfRooms: 5,
                    numberOfBeds: 3,
                    baths: 2,
                    squareFootage: 1800.0,
                    hasGarage: true,
                    mainImageBase64: placeholderBase64,
                    galleryImagesBase64: []
                )
            ]
        }
}
