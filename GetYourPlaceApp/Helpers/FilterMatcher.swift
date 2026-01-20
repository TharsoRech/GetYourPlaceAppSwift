import Foundation
struct FilterMatcher {
    static func check(_ value: Int, satisfies requirement: String?) -> Bool {
        guard let requirement = requirement, requirement != "All" else {
            return true
        }
        
        // Handle "None" as exactly 0
        if requirement == "None" {
            return value == 0
        }
        
        // Handle "4+" (or any number with a plus)
        if requirement.contains("+") {
            let numericPart = requirement.replacingOccurrences(of: "+", with: "")
            if let target = Int(numericPart) {
                return value >= target
            }
        }
        
        // Handle exact numeric match (e.g., "1", "2", "3")
        if let target = Int(requirement) {
            return value == target
        }
        
        return true
    }
}
