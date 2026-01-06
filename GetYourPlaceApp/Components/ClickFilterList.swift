import SwiftUI

struct ClickFilterList: View {
    var  filters: [String] = []
    var onClickFilter: (String) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(filters, id: \.self) { filter in
                                        ClickFilter(title: filter, action: { onClickFilter(filter) })
                                    }
                }
                .padding(.horizontal, 16)
            }
    }
}

#Preview {
    ClickFilterList(filters: ["All", "Tech", "Design", "News"]) { selectedFilter in
            print("Selected: \(selectedFilter)")
        }
}
