import Foundation
import SwiftUI

class Residence: Identifiable {
    let id = UUID()
    var name: String
    var address: String
    var location: String
    var type: String
    var price: Double
    var numberOfRooms: Int
    var numberOfBeds: Int
    var baths: Int
    var squareFootage: Double
    var hasGarage: Bool
    var numberOfGarages: Int
    var rating: Double = 0.0
    var createdAt: Date = Date()
    
    // Image properties
    var mainImageBase64: String
    var galleryImagesBase64: [String]
    
    // MARK: - Formatters
    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: price)) ?? "$\(price)"
    }
    
    var formattedLocation: String { "Location: \(location), \(address)" }
    var formattedNumberOfBeds: String { "\(numberOfBeds) Beds" }
    var formattedNumberOfRooms: String { "\(numberOfRooms) Rooms" }
    var formattedNumberOfGarages: String { "\(numberOfGarages) Garage" }
    var formattedNumberOfbaths: String { "\(baths) Baths" }
    
    // MARK: - Initializer
    init(name: String, address: String, location: String, type: String, price: Double, numberOfRooms: Int, numberOfBeds: Int, baths: Int, squareFootage: Double, hasGarage: Bool, numberOfGarages: Int,rating:Double,createdAt:Date, mainImageBase64: String, galleryImagesBase64: [String]) {
        self.name = name
        self.address = address
        self.location = location
        self.type = type
        self.price = price
        self.numberOfRooms = numberOfRooms
        self.numberOfBeds = numberOfBeds
        self.baths = baths
        self.squareFootage = squareFootage
        self.hasGarage = hasGarage
        self.numberOfGarages = numberOfGarages
        self.mainImageBase64 = mainImageBase64
        self.galleryImagesBase64 = galleryImagesBase64
        self.rating = rating
        self.createdAt = createdAt
    }
    
    // MARK: - Mock Data
    static var mock: Residence {
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
            rating:5.0,
            createdAt: Date(),
            mainImageBase64: "", // Use empty string if asset helper isn't available
            galleryImagesBase64: []
        )
    }
    
    // Used for the Skeleton View loop
    static var mocks: [Residence] {
        [mock, mock, mock]
    }
}
