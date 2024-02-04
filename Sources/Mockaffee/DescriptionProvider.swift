import Foundation

/// A type that provides a description of a given object.
protocol DescriptionProvider {
    func description(of object: Any?) -> String
}

/// This type provides a description by using the built-in `String(describing:)` mechanism.
///
/// In the context of the Mockaffee package, it is used by `Mock` to create an unique
/// representation of a function call.
struct DefaultDescriptionProvider: DescriptionProvider {
    
    //: MARK: - PROPERTIES
    
    private static let argumentSeparator = "#"
    private static let valueTypeSeparator = "*"
    
    //: MARK: - METHODS
    
    /// This method provides a description for the specified object.
    ///
    /// The description has the following format: `value*type#`. For value types, the
    /// value is the object itself. For reference types, the value is the unique object
    /// identifier. Consider the following examples.
    ///
    /// ```swift
    /// let dp = DefaultDescriptionProvider()
    ///
    /// enum SomeEnum { case someCase }
    /// struct SomeStruct { let someVar = 203 }
    /// class SomeClass {}
    ///
    /// dp.description(of: nil) // nil#
    /// dp.description(of: 174) // 174*Int#
    /// dp.description(of: SomeEnum.someCase) // someCase*SomeEnum#
    /// dp.description(of: SomeStruct()) // SomeStruct(someVar: 203)*SomeStruct#
    /// dp.description(of: SomeClass()) // 105553116333216*SomeClass#
    /// ```
    ///
    /// If two objects produce the same description, they are considered to be equal.
    ///
    /// - Parameter object: The object to describe
    /// - Returns: The description of the given object
    func description(of object: Any?) -> String {
        guard let object = object else {
            return "nil\(Self.argumentSeparator)"
        }
        
        let displayStyle = Mirror(reflecting: object).displayStyle
        let subjectType = Mirror(reflecting: object).subjectType
        
        // Since sets and dictionaries are unordered collections, they are sorted
        // beforehand to guarantee consistency.
        var description = switch displayStyle {
            case .class: String(UInt(bitPattern: ObjectIdentifier(object as AnyObject)))
            case .set: String(describing: (object as! Set<AnyHashable>)
                .sorted { $0.hashValue < $1.hashValue })
            case .dictionary: String(describing: (object as! Dictionary<AnyHashable, Any>)
                .sorted { $0.key.hashValue < $1.key.hashValue })
            default: String(describing: object)
        }
        
        description.append(
            Self.valueTypeSeparator +
            String(describing: subjectType) +
            Self.argumentSeparator
        )
        
        return description
    }
}
