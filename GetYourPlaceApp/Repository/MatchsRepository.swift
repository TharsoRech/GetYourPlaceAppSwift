import Foundation
class MatchsRepository: MatchsRepositoryProtocol {
    func getMatchs() async -> [InterestedProfile] {
        try? await Task.sleep(for: .seconds(2))
        
        return [           InterestedProfile(name: "Alex Johnson", residenceName: "Sunset Villa", imageUrl: ""),
                           InterestedProfile(name: "Sarah Smith", residenceName: "Urban Loft", imageUrl: ""),
                           InterestedProfile(name: "Jordan Lee", residenceName: "Sunset Villa", imageUrl: ""),
                           InterestedProfile(name: "Taylor Reed", residenceName: "Mountain Cabin", imageUrl: "")
        ]
    }
}
