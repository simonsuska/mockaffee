import Foundation

protocol BehaviorRegister: Register {
    func record(_ value: Value, for key: String)
}

final class ReturnBehaviorRegister: BehaviorRegister {
    private var register: [String : Any] = [:]
    
    func record(_ value: Any, for key: String) {
        #warning("TODO: Implement")
    }
    
    func fetchValue(for key: String) -> Any? {
        #warning("TODO: Implement")
        return nil
    }
}
