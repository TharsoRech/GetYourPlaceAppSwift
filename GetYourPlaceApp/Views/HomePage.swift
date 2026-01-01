import SwiftUI

struct HomePage: View {
    
    @State private var viewModel = HomePageViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    HomePage()
}
