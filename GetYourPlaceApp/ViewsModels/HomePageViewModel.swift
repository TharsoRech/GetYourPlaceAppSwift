import SwiftUI

@Observable
class HomePageViewModel {
    var count: Int = 0
    var message: String = "Keep going!"
    
    func increment() {
        count += 1
        if count >= 10 {
            message = "Great job!"
        }
    }
}

#Preview {
    HomePage()
}
