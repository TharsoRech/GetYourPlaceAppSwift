import SwiftUI

struct CityPickerView: View {
    @Binding var filter: ResidenceFilter
    @State private var searchText: String = ""
    @State private var showSuggestions: Bool = true

    var filteredCities: [String] {
        if searchText.isEmpty || !showSuggestions { return [] }
        
        // 1. Filter matches
        let matches = filter.cities.filter {
            $0.localizedCaseInsensitiveContains(searchText)
        }
        
        // 2. Remove duplicates using Set and sort alphabetically
        return Array(Set(matches)).sorted()
    }

    var body: some View {
        VStack(alignment: .leading) {
            TextField("Search City...", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .onChange(of: searchText) { _, newValue in
                    filter.selections["city"] = newValue
                    showSuggestions = true
                }
                .overlay(alignment: .topLeading) {
                    // 3. Place suggestions in an overlay so they "float"
                    if !filteredCities.isEmpty {
                        suggestionList
                            .offset(y: 40) // Position it right below the text field
                    }
                }
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
            .background(Color.gray.opacity(0.9))
            .cornerRadius(8)
            .shadow(radius: 5)
        }
        .frame(maxHeight: 200) // Keep the dropdown from taking over the screen
    }

    private var selectCity: (String) -> Void {
        { city in
            searchText = city
            filter.selections["city"] = city
            showSuggestions = false
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

// MARK: - Corrected Preview
#Preview {
    ZStack {
        Color.gray.ignoresSafeArea() // Background to see white text
        CityPickerView(
            filter: .constant(ResidenceFilter())
        )
        .padding()
    }
}
