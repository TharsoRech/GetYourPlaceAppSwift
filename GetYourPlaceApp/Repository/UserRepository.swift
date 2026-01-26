import Foundation

class UserRepository: UserRepositoryProtocol {
    func getUserConfiguration() async -> UserProfile {
        try? await Task.sleep(nanoseconds: 500_000_000) 
                
                return UserProfile(
                    name: "Melissa Peters",
                    email: "melpeters@gmail.com",
                    password: "securedPassword123",
                    dob: "23/05/1995",
                    country: "Nigeria",
                    bio: "UI/UX Designer and mobile developer. Passionate about clean code and dark mode interfaces."
                )
    }
}

