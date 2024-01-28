import Foundation

final class Library {
    enum RegisterID: CaseIterable {
        case functionCallRegister
        case returnBehaviorRegister
        
        func initialize() -> any Register {
            #warning("TODO: Implement")
            return FunctionCallRegister()
        }
    }
    
    private var registers: [RegisterID: any Register]
    
    init() {
        #warning("TODO: Implement")
        self.registers = [:]
    }
    
    func getCount(for key: String, in registerID: RegisterID) -> UInt {
        #warning("TODO: Implement")
        return 0
    }
    
    func increase(for key: String, in registerID: RegisterID) {
        #warning("TODO: Implement")
    }
    
    func getValue(for key: String, in registerID: RegisterID) -> Any? {
        #warning("TODO: Implement")
        return nil
    }
    
    func setValue(_ value: Any, for key: String, in registerID: RegisterID) {
        #warning("TODO: Implement")
    }
}
