import SwiftUI

struct AccordionView<Content: View>: View {
    @Binding var text: String
    @State var isAccordionExpanded: Bool = false
    
    let maxHeight: CGFloat = 400
    let content: () -> Content

    var body: some View {
        VStack {
            DisclosureGroup(text, isExpanded: $isAccordionExpanded) {
                // The ScrollView here is now the ONLY scrollview
                ScrollView {
                    VStack {
                        content()
                    }
                    // This padding ensures the content isn't touching the edges
                    .padding(.horizontal, 4)
                }
                .frame(maxHeight: maxHeight)
                .padding(.top, 10)
            }
            .accentColor(.white)
            .foregroundColor(.white)
            .padding()
            .background(Color.black)
            .cornerRadius(8)
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
}

#Preview {
    AccordionView(text: .constant("Property Details")) {
        Text("This is the hidden content inside the accordion!")
            .foregroundColor(.secondary).foregroundColor(.white)
    }
}
