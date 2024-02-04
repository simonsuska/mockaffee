import Foundation

/// A type that counts the occurences of strings.
protocol CallRegister: Register {
    func increase(for key: String)
    func getCount(for key: String) -> UInt
}

/// This type keeps book about preceding function calls.
final class FunctionCallRegister: CallRegister {
    private var register: [String : UInt] = [:]
    
    /// This method increases the count for the specified key by 1.
    ///
    /// - Parameter key: The unique function identifier
    func increase(for key: String) {
        self.register[key, default: 0] += 1
    }
    
    /// This method returns the count for the specified key.
    ///
    /// - Parameter key: The unique function identifier
    /// - Returns: The count for the given key
    func getCount(for key: String) -> UInt {
        self.register[key, default: 0]
    }
}
