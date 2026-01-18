import SwiftUI

struct ClickFilterList: View {
    var filters: [String] = []
    @State private var selectedFilter: String? = "Newest" // Track selection here
    var onClickFilter: (String) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(filters, id: \.self) { filter in
                    ClickFilter(
                        title: filter,
                        isSelected: selectedFilter == filter, // Check if this is the active one
                        action: {
                            selectedFilter = filter // Update state
                            onClickFilter(filter)
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    VStack {
        ClickFilterList(filters: ["All", "Tech", "Design", "News"]) { selected in
            print("Selected filter is now: \(selected)")
        }
    }
}
