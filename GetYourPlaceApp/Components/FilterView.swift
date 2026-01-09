import SwiftUICore
import SwiftUI

struct FilterView: View {
    @Binding var filter: ResidenceFilter
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color(red: 0.1, green: 0.1, blue: 0.1)
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 25) {
                    // Price Slider
                    VStack(alignment: .leading) {
                        Text("Price Range (up to $\(Int(filter.maxPrice)))")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Slider(value: $filter.maxPrice, in: 500...10000, step: 100)
                            .tint(.white) // Makes the slider bar white
                    }

                    // Residence Type Picker
                    VStack(alignment: .leading) {
                        Text("Property Type")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Picker("Type", selection: $filter.residenceType) {
                            ForEach(filter.types, id: \.self) { type in
                                Text(type) // No need for .foregroundColor here with .dark scheme
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    Spacer()

                    // Action Button
                    Button(action: { dismiss() }) {
                        Text("Apply Filters")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white) // Changed to white background for contrast
                            .foregroundColor(.black) // Black text for the button
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            // 1. Force the navigation bar and items to be white
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        // 2. Force the entire view and its subviews to use Dark Mode logic
        .preferredColorScheme(.dark)
    }
}

#Preview {
    FilterView(filter: .constant(ResidenceFilter()))
}
