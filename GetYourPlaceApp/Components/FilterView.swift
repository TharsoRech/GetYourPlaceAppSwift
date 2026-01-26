import SwiftUICore
import SwiftUI

struct FilterView: View {
    @Binding var filter: ResidenceFilter
    @Environment(\.dismiss) var dismiss
    var applyChanges: (Bool) -> Void

    // The local draft copy
    @State private var draftFilter: ResidenceFilter

    init(filter: Binding<ResidenceFilter>, applyChanges: @escaping (Bool)  -> Void) {
        self._filter = filter
        // We initialize the @State with the current value of the binding
        self._draftFilter = State(initialValue: filter.wrappedValue)
        self.applyChanges = applyChanges
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.1, green: 0.1, blue: 0.1)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // Passes the binding of the draft to the child view
                        CityPickerView(filter: $draftFilter)
                        
                        // Price Slider
                        VStack(alignment: .leading) {
                            Text("Price Range (up to $\(Int(draftFilter.maxPrice)))")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Slider(value: $draftFilter.maxPrice, in: 0...10000000, step: 100)
                                .tint(.white)
                                .onChange(of: draftFilter.maxPrice) { _, newValue in
                                    draftFilter.selections["Price"] = "$\(Int(newValue))"
                                }
                        }

                        DynamicPickerSection(filter: $draftFilter)
                        
                        // Square Footage Slider
                        VStack(alignment: .leading) {
                            Text("Square Footage (up to \(Int(draftFilter.maxSquareFootage))m)")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Slider(value: $draftFilter.maxSquareFootage, in: 0...10000, step: 100)
                                .tint(.white)
                                .onChange(of: draftFilter.maxSquareFootage) { _, newValue in
                                    draftFilter.selections["Sqft"] = "\(Int(newValue))m"
                                }
                        }

                        Spacer()

                        Button(action: {
                            // Only now do we save the changes to the main state
                            filter = draftFilter
                            applyChanges(true)
                            dismiss()
                        }) {
                            Text("Apply Filters")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Clear") {
                        resetToDefaults()
                        applyChanges(false)
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func resetToDefaults() {
        draftFilter.maxPrice = 10000
        draftFilter.maxSquareFootage = 10000
        draftFilter.citySelected = ""
        draftFilter.selections = [:]
    }
}
#Preview {
    FilterView(filter:.constant(.mock), applyChanges: { _ in })
}
