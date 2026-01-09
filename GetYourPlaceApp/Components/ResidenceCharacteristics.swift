import SwiftUI

struct ResidenceCharacteristics: View {
    
    // Use standard properties unless you need to change these values
    // from INSIDE this view and have it reflect in the parent.
    var text: String
    var iconName: String // Passing the name is more flexible for SF Symbols
    
    var body: some View {
        HStack {
            Text(text)
                .fontWeight(.semibold)
                .font(.system(size: 14))
                .foregroundColor(.black)
        
            Image(systemName: iconName)
                .font(.system(size: 14)) // Adjusted size to fit better in the pill
                .foregroundColor(.black)
        }
        .padding(.horizontal,12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(Color.gray.opacity(0.2))
        )
        .frame(maxWidth: .infinity ,maxHeight: 100)
    }
}

#Preview {
    VStack(spacing: 20) {
        ResidenceCharacteristics(text: "3 Bedrooms", iconName: "bed.double.fill")
    }
    .padding()
}
