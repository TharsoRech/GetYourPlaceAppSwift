import SwiftUI
import Observation

@Observable
class UserProfile {
    var name: String?
    var email: String?
    var password: String?
    var dob: String?
    var country: String?
    var bio: String?
    
    // Initializer with nil defaults makes it very "easy to create"
    init(
        name: String? = nil,
        email: String? = nil,
        password: String? = nil,
        dob: String? = nil,
        country: String? = nil,
        bio: String? = nil
    ) {
        self.name = name
        self.email = email
        self.password = password
        self.dob = dob
        self.country = country
        self.bio = bio
    }
}
