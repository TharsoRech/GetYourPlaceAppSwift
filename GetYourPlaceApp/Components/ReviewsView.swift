import SwiftUI

struct ReviewsView: View {
    @StateObject var viewModel: ReviewsViewModel
    
    init(viewModel: ReviewsViewModel = ReviewsViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.1, blue: 0.1).ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    if viewModel.isLoading && viewModel.reviews.isEmpty {
                        ForEach(0..<3, id: \.self) { _ in
                            skeletonCard
                        }
                    } else if viewModel.reviews.isEmpty {
                        emptyStateView
                    } else {
                        ForEach(viewModel.reviews) { review in
                            reviewCard(review)
                        }
                    }
                }
                .padding(24)
            }
        }
        .foregroundColor(.white)
        .onAppear {
            viewModel.fetchReviews()
        }
    }
    
    private var skeletonCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 20, height: 20)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 40, height: 15)
                Spacer()
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 60, height: 12)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(maxWidth: .infinity)
                    .frame(height: 14)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 200)
                    .frame(height: 14)
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .shimmering() // <--- Your custom modifier
    }
    
    @ViewBuilder
    private func reviewCard(_ review: UserReview) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "star.fill").foregroundColor(.yellow)
                Text(String(format: "%.1f", review.rating)).bold()
                Spacer()
                Text(review.relativeDate)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Text(review.comment)
                .font(.body)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }

    private var emptyStateView: some View {
        Text("No reviews yet")
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 50)
    }
}

#Preview {
    ReviewsView()
}
