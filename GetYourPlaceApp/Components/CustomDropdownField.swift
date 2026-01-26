import SwiftUI

struct CustomDropdownField: View {
    let label: String
    @Binding var value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.gray)
            
            HStack {
                Text(value)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "chevron.down")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

#Preview {
    CustomDropdownField(
                    label: "COUNTRY",
                    value: .constant("Nigeria")
                )
}
