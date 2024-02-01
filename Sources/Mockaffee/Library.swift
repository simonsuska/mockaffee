import Foundation

final class Library {
    enum RegisterID: CaseIterable {
        case functionCallRegister
        case returnBehaviorRegister
        case throwBehaviorRegister
        
        func initialize() -> any Register {
            return switch self {
                case .functionCallRegister: FunctionCallRegister()
                case .returnBehaviorRegister: DefaultBehaviorRegister<Any>()
                case .throwBehaviorRegister: DefaultBehaviorRegister<Error>()
            }
        }
    }
    
    private var registers: [RegisterID: any Register]
    
    init() {
        self.registers = [:]
        RegisterID.allCases.forEach {
            self.registers[$0] = $0.initialize()
        }
    }
    
    func getCount(for key: String, in registerID: RegisterID) -> UInt {
        guard let register = self.registers[registerID] as? any CallRegister else {
            return 0
        }
        
        return register.getCount(for: key)
    }
    
    func increase(for key: String, in registerID: RegisterID) {
        guard let register = self.registers[registerID] as? any CallRegister else {
            return
        }
        
        register.increase(for: key)
    }
    
    func getValue(for key: String, in registerID: RegisterID) -> Any? {
        guard let register = self.registers[registerID] as? any BehaviorRegister else {
            return nil
        }
        
        return register.fetchValue(for: key)
    }
    
    func setValue<T>(_ value: T, for key: String, in registerID: RegisterID) {
        guard let register = self.registers[registerID] as? DefaultBehaviorRegister<T> else {
            return
        }
        
        register.record(value, for: key)
    }
}
