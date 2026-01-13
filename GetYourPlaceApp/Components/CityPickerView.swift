import SwiftUI

struct CityPickerView: View {
    @Binding var filter: ResidenceFilter
    @State private var searchText: String = ""
    @State private var showSuggestions: Bool = true

    var filteredCities: [String] {
        if searchText.isEmpty || !showSuggestions { return [] }
        let matches = filter.cities.filter {
            $0.localizedCaseInsensitiveContains(searchText)
        }
        return Array(Set(matches)).sorted()
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("City") // Added label for clarity
                .font(.headline)
                .foregroundColor(.white)

            TextField("Search City...", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .foregroundColor(.white) // Ensure text is visible
                .onChange(of: searchText) { _, newValue in
                    // 1. UPDATE: Save to both the dictionary AND the property
                    filter.citySelected = newValue
                    filter.selections["city"] = newValue
                    showSuggestions = true
                }
                .overlay(alignment: .topLeading) {
                    if !filteredCities.isEmpty {
                        suggestionList
                            .offset(y: 40)
                            .zIndex(1) // Ensure it floats above other elements
                    }
                }
        }
        // 2. IMPORTANT: Load existing city when the modal opens
        .onAppear {
            searchText = filter.citySelected
        }
    }

    private var suggestionList: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(filteredCities, id: \.self) { city in
                    Button(action: {
                        selectCity(city)
                    }) {
                        Text(city)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Divider().background(Color.white.opacity(0.2))
                }
            }
            .background(Color.gray.opacity(0.95))
            .cornerRadius(8)
        }
        .frame(maxHeight: 200)
    }

    private func selectCity(_ city: String) {
        searchText = city
        // 3. UPDATE: Sync both locations
        filter.citySelected = city
        filter.selections["city"] = city
        showSuggestions = false
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea() // Background to see white text
        CityPickerView(filter: .constant(.mock))
                    .padding()
    }
}
