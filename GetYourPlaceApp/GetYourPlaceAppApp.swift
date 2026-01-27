import SwiftUI

@main
struct GetYourPlaceAppApp: App {
    let persistenceController = PersistenceController.shared
    @State private var isActive = false

    var body: some Scene {
        WindowGroup {
                    if isActive {
                        HomeScreen()
                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    } else {
                        SplashScreenView()
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    withAnimation {
                                        self.isActive = true
                                    }
                                }
                            }
                    }
                }
    }
}
