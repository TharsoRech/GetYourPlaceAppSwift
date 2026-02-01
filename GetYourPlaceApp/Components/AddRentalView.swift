import SwiftUI

struct AddRentalView: View {
    @Environment(\.dismiss) var dismiss
    @State private var propertyName = ""
    @State private var location = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    var onSave: (RentalHistory) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Property Details") {
                    TextField("Property Name", text: $propertyName)
                    TextField("Location", text: $location)
                }
                
                Section("Dates") {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }
            }
            .navigationTitle("New Rental")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let new = RentalHistory(
                            id: UUID(),
                            propertyName: propertyName,
                            location: location,
                            startDate: startDate,
                            endDate: endDate,
                            status: .upcoming
                        )
                        onSave(new)
                        dismiss()
                    }
                    .disabled(propertyName.isEmpty || location.isEmpty)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Preview
#Preview("Add Rental Popup") {
    AddRentalView(onSave: { newRental in
        print("Saved: \(newRental.propertyName)")
    })
}
