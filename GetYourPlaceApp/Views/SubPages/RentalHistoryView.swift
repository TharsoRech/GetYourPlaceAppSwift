import SwiftUI

struct RentalHistoryView: View {
    @StateObject var viewModel: RentalHistoryViewModel
    @State private var isShowingAddPopup = false
    
    init(viewModel: RentalHistoryViewModel = RentalHistoryViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
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
            }
            .navigationTitle("Rental History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isShowingAddPopup = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }
            }
            .sheet(isPresented: $isShowingAddPopup) {
                AddRentalView { newRental in
                    viewModel.addRental(newRental)
                }
            }
            .onAppear {
                viewModel.fetchRentals()
            }
        }
        .preferredColorScheme(.dark)
    }
    
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
        .shimmering() // Your custom modifier
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
