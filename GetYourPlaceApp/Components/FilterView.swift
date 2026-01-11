import SwiftUICore
import SwiftUI

struct FilterView: View {
    @Binding var filter: ResidenceFilter
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView{
                ZStack {
                    // Background color
                    Color(red: 0.1, green: 0.1, blue: 0.1)
                        .ignoresSafeArea()

                    VStack(alignment: .leading, spacing: 25) {
                        
                        CityPickerView(filter: $filter)
                        
                        // Price Slider
                        VStack(alignment: .leading) {
                            Text("Price Range (up to $\(Int(filter.maxPrice)))")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Slider(value: $filter.maxPrice, in: 500...10000, step: 100)
                                .tint(.white) // Makes the slider bar white
                        }

                        DynamicPickerSection(filter: $filter)
                        
                        VStack(alignment: .leading) {
                            Text("Square Footage (up to \(Int(filter.maxSquareFootage))m)")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Slider(value: $filter.maxSquareFootage, in: 500...10000, step: 100)
                                .tint(.white) // Makes the slider bar white
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
}

#Preview {
    FilterView(filter: .constant(ResidenceFilter()))
}
