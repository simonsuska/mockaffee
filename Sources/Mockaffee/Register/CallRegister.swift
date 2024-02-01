import Foundation

protocol CallRegister: Register {
    func increase(for key: String)
    func getCount(for key: String) -> UInt
}

final class FunctionCallRegister: CallRegister {
    private var register: [String : UInt] = [:]
    
    func increase(for key: String) {
        self.register[key, default: 0] += 1
    }
    
    func getCount(for key: String) -> UInt {
        self.register[key, default: 0]
    }
}
