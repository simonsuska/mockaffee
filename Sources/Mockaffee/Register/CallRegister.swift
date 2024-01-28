import Foundation

protocol CallRegister: Register {
    func increase(for key: String)
}

final class FunctionCallRegister: CallRegister {
    private var register: [String : UInt] = [:]
    
    func increase(for key: String) {
        #warning("TODO: Implement")
    }
    
    func fetchValue(for key: String) -> UInt? {
        #warning("TODO: Implement")
        return nil
    }
}
