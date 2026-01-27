import SwiftUI
import CoreData

struct HomeScreen: View {
    @Environment(\.managedObjectContext,) private var viewContext
    @State private var navigateToHome = false
    @State private var authManager = AuthManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("dream_home")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    VStack(spacing: 12) {
                        Image("GetYourPlaceIcon")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                        
                        Text("Get Your Place")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    VStack {
                        Text("Your Real Estate Partner Anytime, Anywhere. Find the Perfect Place That Fits your Lifestyle.")
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.black.opacity(0.7)))
                    .padding(.horizontal, 70)
                    .padding(.bottom, 20)
                    
                    ArrowButton(title: "Find Your Own Place") {
                        navigateToHome = true
                    }
                    .padding(.horizontal, 70)
                    .padding(.bottom, 30)
                }
            }
            .navigationDestination(isPresented: $navigateToHome) {
                HomePage().environment(authManager)
            }
        }
    }
}

#Preview {
    HomeScreen().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
