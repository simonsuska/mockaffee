import Foundation

protocol BehaviorRegister: Register {
    associatedtype Value
    
    func record(_ value: Value, for key: String)
    func fetchValue(for key: String) -> Value?
}

final class DefaultBehaviorRegister<Value>: BehaviorRegister {
    private var register: [String : Value] = [:]
    
    func record(_ value: Value, for key: String) {
        self.register[key] = value
    }
    
    func fetchValue(for key: String) -> Value? {
        self.register[key]
    }
}
