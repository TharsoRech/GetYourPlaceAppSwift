import SwiftUI

struct AccordionView<Content: View>: View {
    @Binding var text: String
    @State var isAccordionExpanded: Bool = false
    
    let maxHeight: CGFloat = 500
    let content: () -> Content

    var body: some View {
        VStack {
            DisclosureGroup(isExpanded: $isAccordionExpanded) {
                ScrollView {
                         content()
                       }
                       .padding(.top,16)
                       .frame(maxHeight: maxHeight)
            } label: {
                Text(text)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .accentColor(.white)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.black)
            .cornerRadius(8)
        }
        .padding(.horizontal, 8)
        .padding(.top, 16)
    }
}

#Preview {
    AccordionView(text: .constant("Published Properties")) {
        ResidenceListView(
            // Wrap the entire array in .constant()
            residences: .constant(Residence.mocks),
            isLoading: false,
            isFetchingMore: false,
            // You can also pass the scrollable flag if needed
            isScrollable: false,
            onLoadMore: { },
            onSelect: { _ in }
        )
    }
}
