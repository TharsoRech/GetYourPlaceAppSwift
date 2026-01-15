import SwiftUI

struct ClickFilter: View {
    let title: String
    let isSelected: Bool // Pass this in
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.semibold)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .foregroundColor(isSelected ? .black : .white)
                .background(
                    RoundedRectangle(cornerRadius: 32)
                        .fill(isSelected ? Color.white : Color.black.opacity(0.9))
                )
        }
    }
}

#Preview {
    ClickFilter(title: "Any Type", isSelected: false,action: {})
}
