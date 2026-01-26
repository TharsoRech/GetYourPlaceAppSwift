import SwiftUI

struct CustomDescriptionField: View {
    let label: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.gray)
            
            TextEditor(text: $text)
                .frame(height: 100) // Fixed height for "About" section
                .padding(12)
                .scrollContentBackground(.hidden) // Makes it transparent
                .background(Color.white.opacity(0.05))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .foregroundColor(.white)
        }
    }
}

#Preview("About Field") {
    @Previewable @State var aboutText = "I'm a UI/UX Designer based in Lagos. I love creating clean and functional interfaces for mobile apps."
    
    ZStack {
        // Dark background to match your app theme
        Color(red: 0.1, green: 0.1, blue: 0.1)
            .ignoresSafeArea()
        
        CustomDescriptionField(
            label: "ABOUT",
            text: $aboutText
        )
        .padding()
    }
}
