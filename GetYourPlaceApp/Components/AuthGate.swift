import SwiftUI

struct AuthGate<Content: View>: View {
    @Environment(AuthManager.self) private var auth
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            content
                .blur(radius: auth.isAuthenticated ? 0 : 5)
                .disabled(!auth.isAuthenticated)
            
            if !auth.isAuthenticated {
                LoginPopupView(isPresented: .init(
                    get: { !auth.isAuthenticated },
                    set: { _ in }
                ))
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(1) // Ensures it stays on top during transitions
            }
        }
        .animation(.spring(), value: auth.isAuthenticated)
    }
}
