import SwiftUI

struct ResidenceListView: View {
    @ObservedObject var viewModel: HomePageViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 16) {
                if viewModel.isLoading && viewModel.residences.isEmpty {
                    skeletonStack
                } else {
                    residenceList // Extracted logic
                    
                    if viewModel.isFetchingMore{
                        skeletonStack
                    }
                }
            }
            .padding(.vertical, 8)
            .padding(.bottom, 100)
        }
    }
    
    // MARK: - Sub-views
    
    private var residenceList: some View {
        ForEach(viewModel.residences) { residence in
            ResidenceView(residence: residence)
                .onAppear {
                    // Check if this is the last item to trigger pagination
                    if residence.id == viewModel.residences.last?.id {
                        viewModel.loadNextPage()
                    }
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
                    .padding(.horizontal,16)
                    .shimmering()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 150, height: 20)
                    .padding(.horizontal,16)
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
