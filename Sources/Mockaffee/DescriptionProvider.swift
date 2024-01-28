import Foundation

protocol DescriptionProvider {
    func description(of object: Any?) -> String
}

struct DefaultDescriptionProvider: DescriptionProvider {
    private static let argumentSeparator = "#"
    private static let valueTypeSeparator = "*"
    
    func description(of object: Any?) -> String {
        #warning("TODO: Implement")
        return ""
    }
}
