import SwiftUI
import Observation

@Observable
class UserProfile: Codable {
    var name: String?
    var email: String?
    var password: String?
    var dob: String?
    var country: String?
    var bio: String?
    var role: UserRole?
    var base64Image: String?

    init(
        name: String? = nil,
        email: String? = nil,
        password: String? = nil,
        dob: String? = nil,
        country: String? = nil,
        bio: String? = nil,
        role: UserRole? = nil,
        base64Image: String? = nil
    ) {
        self.name = name
        self.email = email
        self.password = password
        self.dob = dob
        self.country = country
        self.bio = bio
        self.role = role
        self.base64Image = base64Image
    }

    enum CodingKeys: String, CodingKey {
        case name, email, password, dob, country, bio, role, base64Image
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        password = try container.decodeIfPresent(String.self, forKey: .password)
        dob = try container.decodeIfPresent(String.self, forKey: .dob)
        country = try container.decodeIfPresent(String.self, forKey: .country)
        bio = try container.decodeIfPresent(String.self, forKey: .bio)
        role = try container.decodeIfPresent(UserRole.self, forKey: .role)
        base64Image = try container.decodeIfPresent(String.self, forKey: .base64Image)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encode(dob, forKey: .dob)
        try container.encode(country, forKey: .country)
        try container.encode(bio, forKey: .bio)
        try container.encode(role, forKey: .role)
        try container.encode(base64Image, forKey: .base64Image)
    }
    
    /// Converts the base64 string into a SwiftUI Image for easy display
    var profileImage: Image {
        if let base64String = base64Image,
           let data = Data(base64Encoded: base64String),
           let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }
        return Image(systemName: "person.crop.circle.fill")
    }

    static var mock: UserProfile {
        UserProfile(
            name: "Alex Sterling",
            email: "alex.sterling@example.com",
            password: "secured_password_123",
            dob: "1992-11-24",
            country: "United Kingdom",
            bio: "Avid traveler, architecture lover, and host of three properties in London.",
            role: .owner,
            // A simple 1x1 grey pixel Base64 for testing
            base64Image: "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg=="
        )
    }
}
