import SwiftUI

struct AddReviewPopup: View {
    @Environment(\.dismiss) var dismiss
    
    // The required closure
    var onSave: (UserReview) -> Void
    
    @State private var comment: String = ""
    @State private var rating: Int = 5
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.15, green: 0.15, blue: 0.15).ignoresSafeArea()
                
                VStack(spacing: 25) {
                    // Star Picker
                    HStack {
                        ForEach(1...5, id: \.self) { index in
                            Image(systemName: index <= rating ? "star.fill" : "star")
                                .font(.title)
                                .foregroundColor(.yellow)
                                .onTapGesture { rating = index }
                        }
                    }
                    .padding(.top)

                    // Text Editor
                    ZStack(alignment: .topLeading) {
                        if comment.isEmpty {
                            Text("How was your experience?")
                                .foregroundColor(.gray)
                                .padding(12)
                        }
                        TextEditor(text: $comment)
                            .foregroundStyle(.white)
                            .scrollContentBackground(.hidden)
                            .background(Color.white.opacity(0.1))
                            .padding(4)
                    }
                    .frame(height: 150)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    Button(action: {
                        // FIXED: Added missing parameters 'id' and 'reviewerName'
                        // These must match your UserReview struct exactly.
                        let newReview = UserReview(
                            id: UUID(),
                            rating: Double(rating),
                            comment: comment,
                            date: Date(),
                            reviewerName: "Guest" // You can pass a real name here later
                        )
                        
                        onSave(newReview)
                        dismiss()
                    }) {
                        Text("Submit Review")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(comment.isEmpty ? Color.gray : Color.white)
                            .cornerRadius(12)
                    }
                    .disabled(comment.isEmpty)
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationTitle("New Review")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium])
    }
}

#Preview("Add Review Popup") {
    @Previewable @State var isPresented = true
    
    Text("Background Content")
        .sheet(isPresented: $isPresented) {
            AddReviewPopup { review in
                print("Saved review with rating: \(review.rating)")
            }
        }
}
