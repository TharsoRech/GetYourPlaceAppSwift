import SwiftUI
import Observation

@Observable
class AuthManager {
    var isAuthenticated: Bool = false
    private let cacheKey = "user_session"
    var currentUser: UserProfile?
    
    private let profileKey = "user_profile_cache"

    init() {
        // AUTO-LOGIN LOGIC: Check if a profile exists in cache
        if let savedProfile = CacheManager.shared.load(forKey: profileKey, as: UserProfile.self) {
            self.currentUser = savedProfile
            self.isAuthenticated = true
        }
    }

    func login(userProfile: UserProfile) {
            withAnimation(.spring()) {
                self.currentUser = userProfile
                self.isAuthenticated = true
                CacheManager.shared.save(userProfile, forKey: cacheKey)
            }
        }

    func logout() {
        withAnimation(.spring()) {
            self.isAuthenticated = false
            self.currentUser = nil
            // Clear the cache
            CacheManager.shared.remove(forKey: profileKey)
        }
    }
}
