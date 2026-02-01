import SwiftUI

struct RentalHistoryView: View {
    @StateObject var viewModel: RentalHistoryViewModel
    @State private var isShowingAddPopup = false
    
    init(viewModel: RentalHistoryViewModel = RentalHistoryViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) { // Alignment for the Floating Button
            Color(red: 0.1, green: 0.1, blue: 0.1).ignoresSafeArea()
            
            List {
                if viewModel.isLoading && viewModel.rentals.isEmpty {
                    ForEach(0..<5, id: \.self) { _ in
                        rentalSkeletonRow
                    }
                } else if viewModel.rentals.isEmpty {
                    emptyStateView
                } else {
                    ForEach(viewModel.rentals) { rental in
                        rentalRow(rental)
                    }
                    .onDelete(perform: viewModel.deleteRental)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            
            // --- Floating Add Button ---
            Button(action: { isShowingAddPopup = true }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
                    .background(Color.black.clipShape(Circle())) // Shadow contrast
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
            }
            .padding(.bottom, 64)
            .padding(25) // Distance from edges
        }
        .sheet(isPresented: $isShowingAddPopup) {
            AddRentalView { newRental in
                viewModel.addRental(newRental)
            }
        }
        .onAppear {
            viewModel.fetchRentals()
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Row Components (Unchanged)
    
    private func rentalRow(_ rental: RentalHistory) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(rental.propertyName) - \(rental.location)")
                    .font(.headline)
                    .foregroundColor(.white)
                Text(rental.dateRangeString)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(rental.status.rawValue)
                .font(.caption2)
                .bold()
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(rental.status.color.opacity(0.2))
                .foregroundColor(rental.status.color)
                .cornerRadius(5)
        }
        .padding(.vertical, 4)
        .listRowBackground(Color.white.opacity(0.05))
    }
    
    private var rentalSkeletonRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 180, height: 18)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 120, height: 14)
            }
            Spacer()
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 70, height: 24)
        }
        .padding(.vertical, 4)
        .listRowBackground(Color.white.opacity(0.05))
        .shimmering()
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "house.and.flag")
                .font(.largeTitle)
                .foregroundColor(.gray)
            Text("No rentals found")
                .font(.headline)
                .foregroundColor(.gray)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .listRowBackground(Color.clear)
    }
}

#Preview {
    RentalHistoryView(viewModel: RentalHistoryViewModel())
}
