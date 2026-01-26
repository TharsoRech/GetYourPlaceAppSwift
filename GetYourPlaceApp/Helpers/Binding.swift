import Foundation
import SwiftUI
import SwiftUICore

extension Binding where Value == [String: String] {
    /// Creates a proxy binding for a specific key in a Dictionary
    func key(_ key: String) -> Binding<String> {
        Binding<String>(
            get: { self.wrappedValue[key] ?? "" },
            set: { self.wrappedValue[key] = $0 }
        )
    }
}

extension Binding where Value == String? {
    var toUnwrapped: Binding<String> {
        Binding<String>(
            get: { self.wrappedValue ?? "" },
            set: { self.wrappedValue = $0 }
        )
    }
}
