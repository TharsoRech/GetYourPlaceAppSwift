import SwiftUICore
import SwiftUI
struct DynamicPickerSection: View {
    @Binding var filter: ResidenceFilter
    
    var body: some View {
        ForEach(filter.pickerOptions.keys.sorted(), id: \.self) { key in
            Text(key)
                .font(.headline)
                .foregroundColor(.white)
            Picker(key, selection: $filter.selections.key(key)) {
                ForEach(filter.pickerOptions[key] ?? [], id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.segmented)
            .tint(.white)
        }
    }
}

#Preview {
    DynamicPickerSection(filter: .constant(ResidenceFilter()))
}
