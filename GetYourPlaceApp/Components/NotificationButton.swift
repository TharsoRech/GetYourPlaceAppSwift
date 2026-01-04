import SwiftUI

struct NotificationButton: View {
    var count: Int = 3 // Number to show in the badge
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // The Main Circle Button
            Circle()
                .fill(Color(white: 0.2))
                .frame(width: 45, height: 45)
                .overlay(
                    Image(systemName: "bell.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                )
            
            // The Red Badge
            if count > 0 {
                Text("\(count)")
                    .font(.caption2).bold()
                    .foregroundColor(.white)
                    .frame(width: 18, height: 18)
                    .background(Color.red)
                    .clipShape(Circle())
                    // Position it on the top right corner
                    .offset(x: 2, y: -2)
            }
        }
    }
}

#Preview {
    NotificationButton()
}
