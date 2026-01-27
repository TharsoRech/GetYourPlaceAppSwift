import SwiftUI

struct SplashScreenView: View {
    @State private var scale = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        ZStack(alignment: .center) {
            Color(red: 0.1, green: 0.1, blue: 0.1)
                .ignoresSafeArea()
            VStack {
                Text("Welcome To")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                Image("GetYourPlaceIcon")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                Text("Get Your Place")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
            }
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 1.2)) {
                    self.scale = 1.0
                    self.opacity = 1.0
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
