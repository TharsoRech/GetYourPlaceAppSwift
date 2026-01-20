import SwiftUI

struct CustomSearchBar: View {
    @Binding var text: String
    var onSearchTap: () -> Void
    var onFilterTap: () -> Void
    @Binding var isFilterActive: Bool
    
    var body: some View {
        VStack {
            HStack(spacing: 12) {
                // Search Icon Button
                Button(action: onSearchTap) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .font(.system(size: 20))
                }
                
                // Text Field with Clear Button
                HStack {
                    TextField("",
                              text: $text,
                              prompt: Text("Search your home").foregroundColor(.gray)
                    )
                    .submitLabel(.search)
                    .onSubmit { onSearchTap() }
                    .foregroundColor(.white)
                    
                    // The "Clear" Button
                    if !text.isEmpty {
                        Button(action: {
                            self.text = ""
                            onSearchTap() // Optional: refresh search when cleared
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 4)
                        }
                    }
                }
                .padding(10)
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
                
                // Filter Button
                Button(action: onFilterTap) {
                    Image(systemName: isFilterActive ? "line.3.horizontal.decrease.circle.fill": "line.3.horizontal.decrease.circle")
                        .foregroundColor(.white)
                        .font(.system(size: 28))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.1))
            .cornerRadius(15)
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    CustomSearchBar(text: .constant("Example Text"),onSearchTap:{}, onFilterTap: {},isFilterActive: .constant(false))
}
