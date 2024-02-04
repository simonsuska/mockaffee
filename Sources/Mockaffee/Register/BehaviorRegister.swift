import Foundation

/// A type that keeps book about the deposited behaviors
protocol BehaviorRegister: Register {
    associatedtype Value
    
    func record(_ value: Value, for key: String)
    func fetchValue(for key: String) -> Value?
}

/// This type provides a default implementation of the `BehaviorRegister` protocol.
final class DefaultBehaviorRegister<Value>: BehaviorRegister {
    private var register: [String : Value] = [:]
    
    /// This method records a new behavior
    ///
    /// In the context of the Mockaffee package, the key is equal to the unique
    /// representation of a function call provided by the underlying `DescriptionProvider`.
    ///
    /// - Parameters:
    ///     * value: The behavior to be recorded
    ///     * key: The unique key to reference the behavior
    func record(_ value: Value, for key: String) {
        self.register[key] = value
    }
    
    /// This method fetches the recorded behavior for the given key
    ///
    /// In the context of the Mockaffee package, the key is equal to the unique
    /// representation of a function call provided by the underlying `DescriptionProvider`.
    ///
    /// - Parameter key: The unique key to reference the behavior
    /// - Returns: The behavior or `nil`, if the given key does not reference any behavior
    func fetchValue(for key: String) -> Value? {
        self.register[key]
    }
}
