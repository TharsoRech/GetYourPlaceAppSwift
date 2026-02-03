import Foundation
import SwiftUI

class Residence: Identifiable {
    let id = UUID()
    var name: String
    var description: String // New Property
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
    var isPublished: Bool
    
    var mainImageBase64: String
    var galleryImagesBase64: [String]
    var favorite: Bool = false
    
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
    
    // MARK: - Initializer Updated
    init(name: String, description: String, address: String, location: String, type: String, price: Double, numberOfRooms: Int, numberOfBeds: Int, baths: Int, squareFootage: Double, hasGarage: Bool, numberOfGarages: Int, rating: Double, createdAt: Date, mainImageBase64: String, galleryImagesBase64: [String], favorite: Bool, isPublished: Bool = false) {
        self.name = name
        self.description = description
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
        self.favorite = favorite
        self.isPublished = isPublished
    }
    
    static var mock: Residence {
        Residence(
            name: "Modern Villa",
            description: "A beautiful modern villa with sea views and a private pool.",
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
            rating: 5.0,
            createdAt: Date(),
            mainImageBase64: "",
            galleryImagesBase64: [],
            favorite: false
        )
    }
    
    static var mocks: [Residence] {  [
        Residence(
            name: "Modern Villa",
            description: "A beautiful modern villa with sea views and a private pool.",
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
            rating: 5.0,
            createdAt: Date().addingTimeInterval(-10000),
            mainImageBase64: "house1".asAssetBase64, // Nome do Asset
            galleryImagesBase64: ["house1".asAssetBase64, "house1".asAssetBase64],
            favorite: false
        ),
        Residence(
            name: "Skyline Apartment",
            description: "A beautiful modern villa with sea views and a private pool.",
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
            rating: 3.0,
            createdAt: Date().addingTimeInterval(-20000),
            mainImageBase64: "house2".asAssetBase64,
            galleryImagesBase64: ["house2".asAssetBase64],
            favorite: false
        ),
        Residence(
            name: "Cozy Cottage",
            description: "A beautiful modern villa with sea views and a private pool.",
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
            galleryImagesBase64: [] ,
            favorite: false
        )
    ] }
}
