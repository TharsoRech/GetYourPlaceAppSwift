import Foundation
enum FilterMatcher {
    /// Checks if a value satisfies a filter string (e.g., "3" or "4+")
    static func check(_ value: Int, satisfies filterValue: String?) -> Bool {
        // 1. If filter is nil, empty, or "All", it's a match
        guard let filter = filterValue, !filter.isEmpty, filter != "All" else {
            return true
        }
        
        // 2. Handle "plus" logic (e.g., "4+")
        if filter.contains("+") {
            let numericPart = filter.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
            if let target = Int(numericPart) {
                return value >= target
            }
        }
        
        // 3. Handle exact match
        if let target = Int(filter) {
            return value == target
        }
        
        return true
    }
}
