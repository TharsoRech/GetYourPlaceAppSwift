import SwiftUI

struct CustomSearchBar: View {
    @Binding var text: String
    
    var onSearchTap: () -> Void
    
    var onFilterTap: () -> Void
    
    @Binding var isFilterActive: Bool
    
    var body: some View {
        VStack{
            HStack(spacing: 12) {
                Button(action: {
                                onSearchTap()
                            }) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 24))
                            }
                TextField("",
                          text: $text,
                          prompt: Text("Search your home")
                    .foregroundColor(.gray)
                )
                .submitLabel(.search)
                                .onSubmit {
                                    onSearchTap()
                                }
                .padding()
                .foregroundColor(.white)
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
                Button(action: {
                    onFilterTap()
                }) {
                    Image(systemName: isFilterActive ? "line.3.horizontal.decrease.circle.fill": "line.3.horizontal.decrease.circle")
                        .foregroundColor(.white)
                        .font(.system(size: 28))
                }
            }
            .padding(.horizontal, 8)
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
