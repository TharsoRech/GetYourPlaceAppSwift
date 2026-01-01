import SwiftUI

struct ArrowButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
            Button(action: action) {
                HStack(spacing: 10) {
                    Text(title)
                        .fontWeight(.semibold)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .bold)) // Adjusts arrow thickness
                }
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .cornerRadius(12)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.black.opacity(0.9))
                )
            }
        }
}

// Preview
struct ArrowButton_Previews: PreviewProvider {
    static var previews: some View {
        ArrowButton(title: "Get Started") {
            print("Button tapped!")
        }
    }
}
