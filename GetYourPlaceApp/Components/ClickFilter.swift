import SwiftUI

struct ClickFilter: View {
    @State var active: Bool = false
    var title: String
    var action: () -> Void
    
    var body: some View {
            Button(action: {
                active.toggle()
                action()
            }) {
                Text(title)
                        .fontWeight(.semibold)
                .padding()
                .foregroundColor(active ? .black :.white)
                .background(
                    RoundedRectangle(cornerRadius: 32)
                        .fill(active ? Color.white : Color.black.opacity(0.9))
                )
            }
    }
}

#Preview {
    ClickFilter(title: "Any Type", action: {})
}
