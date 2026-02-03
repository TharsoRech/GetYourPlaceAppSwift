import SwiftUI

// MARK: - Public Profile View
struct PublicProfileView: View {
    let profile: UserProfile
    @Environment(\.dismiss) var dismiss
    
    @State private var viewModel = PublicProfileViewModel()
    @State private var showReviewSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color(red: 0.1, green: 0.1, blue: 0.1)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        if viewModel.isLoading {
                            profileSkeleton
                        } else {
                            headerSection
                            aboutSection
                            rentalHistorySection
                            reviewsSection
                        }
                    }
                    .padding(24)
                }
            }
            .navigationTitle("Public Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(.white)
                }
            }
            .sheet(isPresented: $showReviewSheet) {
                AddReviewPopup(onSave: { newReview in
                    viewModel.addReview(newReview)
                })
            }
        }
    }
    
    // MARK: - Skeleton View (Loading State)
    private var profileSkeleton: some View {
        VStack(spacing: 25) {
            // Header Skeleton
            VStack(spacing: 15) {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 100, height: 100)
                    .shimmering()
                
                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 150, height: 24)
                        .shimmering()
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 100, height: 16)
                        .shimmering()
                }
            }
            
            // About Skeleton
            VStack(alignment: .leading, spacing: 12) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 80, height: 20)
                
                VStack(alignment: .leading, spacing: 8) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.1))
                        .frame(maxWidth: .infinity)
                        .frame(height: 14)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 200, height: 14)
                }
            }
            .shimmering()
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(12)
            
            // Lists Skeleton
            VStack(alignment: .leading, spacing: 12) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 120, height: 20)
                    .shimmering()
                
                ForEach(0..<3, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.05))
                        .frame(height: 60)
                        .shimmering()
                }
            }
        }
    }
    
    // MARK: - Content Sub-views
    private var headerSection: some View {
        VStack(spacing: 15) {
            profile.profileImage
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 2))
            
            VStack(spacing: 4) {
                Text(profile.name ?? "User")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                Text(profile.country ?? "Location not set")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("About").font(.headline).foregroundColor(.white)
            Text(profile.bio ?? "No bio available.").foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
    
    private var rentalHistorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Rental History").font(.headline).foregroundColor(.white)
            
            if viewModel.rentals.isEmpty {
                Text("No previous rentals").foregroundColor(.gray).font(.caption)
            } else {
                ForEach(viewModel.rentals) { rental in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(rental.propertyName).foregroundColor(.white).font(.subheadline).bold()
                            Text(rental.dateRangeString).foregroundColor(.gray).font(.caption2)
                        }
                        Spacer()
                        Text(rental.status.rawValue)
                            .font(.caption2)
                            .padding(4)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(4)
                    }
                    .padding()
                    .background(Color.white.opacity(0.03))
                    .cornerRadius(8)
                }
            }
        }
    }
    
    private var reviewsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Reviews").font(.headline).foregroundColor(.white)
                Spacer()
                Button("Write a Review") { showReviewSheet = true }
                    .font(.caption).bold().foregroundColor(.blue)
            }
            
            if viewModel.reviews.isEmpty {
                Text("No reviews yet").foregroundColor(.gray).font(.caption)
            } else {
                ForEach(viewModel.reviews) { review in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: "star.fill").foregroundColor(.yellow).font(.caption)
                            Text(String(format: "%.1f", review.rating)).font(.caption).bold()
                            Spacer()
                            Text(review.relativeDate).font(.caption2).foregroundColor(.gray)
                        }
                        Text(review.comment).font(.footnote).foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(10)
                }
            }
        }
    }
}

#Preview("Public Profile") {
    let mockProfile = UserProfile(
        name: "Alex Sterling",
        email: "alex@example.com",
        country: "United Kingdom",
        bio: "Avid traveler and architecture lover. I've hosted over 50 guests.",
        role: .owner
    )
    
    return PublicProfileView(profile: mockProfile)
        .preferredColorScheme(.dark)
}
