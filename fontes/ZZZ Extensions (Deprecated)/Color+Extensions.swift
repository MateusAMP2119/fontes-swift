import SwiftUI

extension Color {
    
    // MARK: - Perspective Colors (Dark Mode)
    
    /// A muted purple or indigo, representing analytical content.
    static let perspectiveAnalysis = Color(red: 0.55, green: 0.45, blue: 0.75)
    
    /// A muted gold or amber, representing official content.
    static let perspectiveOfficial = Color(red: 0.85, green: 0.70, blue: 0.35)
    
    /// A soft blue or teal, representing global content.
    static let perspectiveGlobal = Color(red: 0.35, green: 0.65, blue: 0.85)
    
    /// A soft green, representing local content.
    static let perspectiveLocal = Color(red: 0.45, green: 0.75, blue: 0.50)
    
    /// Returns the perspective color based on the category name.
    /// - Parameter type: The string representation of the perspective type (e.g., "Analysis", "Official").
    /// - Returns: The corresponding Color, or a default gray if not found.
    static func colorForPerspective(type: String) -> Color {
        switch type.lowercased() {
        case "analysis":
            return .perspectiveAnalysis
        case "official":
            return .perspectiveOfficial
        case "global":
            return .perspectiveGlobal
        case "local":
            return .perspectiveLocal
        default:
            return .gray
        }
    }
}
