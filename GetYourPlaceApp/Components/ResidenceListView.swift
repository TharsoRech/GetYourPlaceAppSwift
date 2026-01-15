import SwiftUI

struct ResidenceListView: View {
    @ObservedObject var viewModel: HomePageViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                if viewModel.isLoading && viewModel.residences.isEmpty {
                    skeletonStack
                } else {
                    residenceList // Extracted logic
                    
                    if viewModel.isFetchingMore{
                        ProgressView()
                            .tint(.white)
                            .padding()
                    }
                }
            }
            .padding(.vertical, 8)
            .padding(.bottom, 100)
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - Sub-views
    
    private var residenceList: some View {
        // Breaking the enumerated array into a separate variable helps the compiler
        let enumeratedResidences = Array(viewModel.residences.enumerated())
        
        return ForEach(enumeratedResidences, id: \.element.id) { index, residence in
            ResidenceView(residence: residence)
                .onAppear {
                    loadMoreIfNeeded(at: index)
                }
        }
    }
    
    private func loadMoreIfNeeded(at index: Int) {
        if index == viewModel.residences.count - 1 {
            viewModel.loadNextPage()
        }
    }

    private var skeletonStack: some View {
        ForEach(0..<3, id: \.self) { _ in
            VStack(alignment: .leading, spacing: 12) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                    .shimmering()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 150, height: 20)
                    .shimmering()
            }
            .padding(.vertical, 12)
        }
    }
}

#Preview("Residence List States") {
    struct PreviewWrapper: View {
        // Mocking the ViewModel state
        @StateObject var loadingVM: HomePageViewModel = {
            let vm = HomePageViewModel()
            vm.isLoading = true
            vm.residences = []
            return vm
        }()
        
        @StateObject var dataVM: HomePageViewModel = {
            let vm = HomePageViewModel()
            vm.isLoading = false
            vm.residences = [Residence.mock, Residence.mock]
            return vm
        }()
        
        var body: some View {
            TabView {
                // Tab 1: Testing the Skeleton
                ZStack {
                    Color(red: 0.1, green: 0.1, blue: 0.1).ignoresSafeArea()
                    ResidenceListView(viewModel: loadingVM)
                }
                .tabItem { Label("Loading", systemImage: "hourglass") }
                
                // Tab 2: Testing the actual List
                ZStack {
                    Color(red: 0.1, green: 0.1, blue: 0.1).ignoresSafeArea()
                    ResidenceListView(viewModel: dataVM)
                }
                .tabItem { Label("Data", systemImage: "list.bullet") }
            }
        }
    }
    
    return PreviewWrapper()
}
