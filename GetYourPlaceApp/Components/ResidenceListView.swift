import SwiftUI

struct ResidenceListView: View {
    @Binding var residences: [Residence]
    let isLoading: Bool
    let isFetchingMore: Bool
    var isScrollable: Bool = true // Add this flag
    let onLoadMore: () -> Void
    
    var body: some View {
        if isScrollable {
            ScrollView(.vertical, showsIndicators: false) {
                listViewContent
            }
        } else {
            listViewContent
        }
    }
    

    private var listViewContent: some View {
        LazyVStack(spacing: 16) {
            if isLoading && residences.isEmpty {
                skeletonStack
            } else {
                residenceList
                if isFetchingMore {
                    skeletonStack
                }
            }
        }
        .padding(.vertical, 8)

    }
    
    
    private var residenceList: some View {
        ForEach($residences) { $residence in
            ResidenceView(residence: $residence)
                .onAppear {
                    if residence.id == residences.last?.id {
                        onLoadMore()
                    }
                }
        }
    }
    
    private var skeletonStack: some View {
        ForEach(0..<3, id: \.self) { _ in
            VStack(alignment: .leading, spacing: 12) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                    .padding(.horizontal, 16)
                    .shimmering()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 150, height: 20)
                    .padding(.horizontal, 16)
                    .shimmering()
            }
            .padding(.vertical, 12)
        }
    }
}

#Preview("Residence List States") {
    TabView {
        // Tab 1: Loading State
        ZStack {
            Color(red: 0.1, green: 0.1, blue: 0.1).ignoresSafeArea()
            ResidenceListView(
                residences: .constant([]), // Fixed with .constant
                isLoading: true,           // Set to true to actually see skeletons
                isFetchingMore: false,
                isScrollable: true,
                onLoadMore: {}
            )
        }
        .tabItem { Label("Loading", systemImage: "hourglass") }
        
        // Tab 2: Data State
        ZStack {
            Color(red: 0.1, green: 0.1, blue: 0.1).ignoresSafeArea()
            ResidenceListView(
                residences: .constant([.mock, .mock, .mock]), // Fixed with .constant
                isLoading: false,
                isFetchingMore: false,
                isScrollable: true,
                onLoadMore: { print("Load more triggered") }
            )
        }
        .tabItem { Label("Data", systemImage: "list.bullet") }
        
        // Tab 3: Accordion Check
        ZStack {
            Color(red: 0.1, green: 0.1, blue: 0.1).ignoresSafeArea()
            AccordionView(text: .constant("Test Accordion")) {
                ResidenceListView(
                    residences: .constant([.mock]), // Fixed with .constant
                    isLoading: false,
                    isFetchingMore: false,
                    isScrollable: false,
                    onLoadMore: {}
                )
            }
        }
        .tabItem { Label("Accordion", systemImage: "chevron.down") }
    }
}
