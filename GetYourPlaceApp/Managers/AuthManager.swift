import SwiftUI
import Observation

@Observable
class AuthManager: ObservableObject {
    var isAuthenticated: Bool = false
    private let cacheKey = "user_session"
    var currentUser: UserProfile?
    
    private let profileKey = "user_profile_cache"

    init() {
        if let savedProfile = CacheManager.shared.load(forKey: profileKey, as: UserProfile.self) {
            self.currentUser = savedProfile
            self.isAuthenticated = true
        }
    }

    func login(userProfile: UserProfile) {
        withAnimation(.spring()) {
            self.currentUser = userProfile
            self.isAuthenticated = true
            CacheManager.shared.save(userProfile, forKey: profileKey)
        }
    }

    func logout() {
        withAnimation(.spring()) {
            self.isAuthenticated = false
            self.currentUser = nil
            CacheManager.shared.remove(forKey: profileKey)
        }
    }
}

extension AuthManager {
    static func mock(role: UserRole) -> AuthManager {
        let auth = AuthManager()
        auth.currentUser = UserProfile(role: role)
        return auth
    }
}
