import SwiftUI
import Observation

@Observable
class UserProfile: Codable {
    var name: String?
    var email: String?
    var password: String? // Note: See security warning below
    var dob: String?
    var country: String?
    var bio: String?

    init(name: String? = nil, email: String? = nil, password: String? = nil, dob: String? = nil, country: String? = nil, bio: String? = nil) {
        self.name = name
        self.email = email
        self.password = password
        self.dob = dob
        self.country = country
        self.bio = bio
    }

    // CodingKeys are required for @Observable classes to tell Swift which properties to encode
    enum CodingKeys: String, CodingKey {
        case name, email, password, dob, country, bio
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        password = try container.decodeIfPresent(String.self, forKey: .password)
        dob = try container.decodeIfPresent(String.self, forKey: .dob)
        country = try container.decodeIfPresent(String.self, forKey: .country)
        bio = try container.decodeIfPresent(String.self, forKey: .bio)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encode(dob, forKey: .dob)
        try container.encode(country, forKey: .country)
        try container.encode(bio, forKey: .bio)
    }
}
