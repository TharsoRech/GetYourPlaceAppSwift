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
    
    // Image properties (Storing as Base64 Strings)
    var mainImageBase64: String
    var galleryImagesBase64: [String]
    
    init(name: String, address: String, location: String, type: String, price: Double, numberOfRooms: Int, numberOfBeds: Int, baths: Int, squareFootage: Double, hasGarage: Bool, mainImageBase64: String, galleryImagesBase64: [String]) {
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
        self.mainImageBase64 = mainImageBase64
        self.galleryImagesBase64 = galleryImagesBase64
    }
}
