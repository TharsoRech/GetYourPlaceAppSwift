import SwiftUI

struct MatchsResidencesView: View {
    
    @StateObject var viewModel: MatchsResidencesViewModel
    
    init(viewModel: MatchsResidencesViewModel = MatchsResidencesViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    MatchsResidencesView()
}
