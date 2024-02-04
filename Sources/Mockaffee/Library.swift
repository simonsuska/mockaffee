import Foundation

/// This type manages multiple registers.
///
/// In the context of the Mockaffee package, every `Mock` possesses exactly one library
/// to keep book about the preceding function calls and recorded behaviors.
final class Library {
    /// This type provides a list of available registers.
    enum RegisterID: CaseIterable {
        case functionCallRegister
        case returnBehaviorRegister
        case throwBehaviorRegister
        
        /// This method ensures that every case references exactly one register.
        ///
        /// It is called only once when the library is created.
        ///
        /// - Returns: The object representing the register
        func initialize() -> any Register {
            return switch self {
                case .functionCallRegister: FunctionCallRegister()
                case .returnBehaviorRegister: DefaultBehaviorRegister<Any>()
                case .throwBehaviorRegister: DefaultBehaviorRegister<Error>()
            }
        }
    }
    
    //: MARK: - PROPERTIES
    
    private var registers: [RegisterID: any Register]
    
    //: MARK: - INITIALIZER
    
    init() {
        self.registers = [:]
        RegisterID.allCases.forEach {
            self.registers[$0] = $0.initialize()
        }
    }
    
    //: MARK: - METHODS
    
    /// This method retrieves the count for the given key from the specified register.
    ///
    /// In the context of the Mockaffee package, the key is equal to the unique
    /// representation of a function call provided by the underlying `DescriptionProvider`.
    ///
    /// - Parameters:
    ///     * key: The unique key
    ///     * registerID: The register to retrieve the count from
    /// - Returns: The count or 0, if the register is not a `CallRegister`
    func getCount(for key: String, in registerID: RegisterID) -> UInt {
        guard let register = self.registers[registerID] as? any CallRegister else {
            return 0
        }
        
        return register.getCount(for: key)
    }
    
    /// This method increases the count for the given key in the specified register.
    ///
    /// In the context of the Mockaffee package, the key is equal to the unique
    /// representation of a function call provided by the underlying `DescriptionProvider`.
    ///
    /// Note that the register has to be a `CallRegister`, otherwise this method will
    /// return without any effect.
    ///
    /// - Parameters:
    ///     * key: The unique key
    ///     * registerID: The register to increase the count in
    func increase(for key: String, in registerID: RegisterID) {
        guard let register = self.registers[registerID] as? any CallRegister else {
            return
        }
        
        register.increase(for: key)
    }
    
    /// This method retrieves the behavior for the given key from the specified register.
    ///
    /// In the context of the Mockaffee package, the key is equal to the unique
    /// representation of a function call provided by the underlying `DescriptionProvider`.
    ///
    /// - Parameters:
    ///     * key: The unique key
    ///     * registerID: The register to retrieve the behavior from
    /// - Returns: The behavior or `nil`, if the register is not a `BehaviorRegister` or
    ///            the key does not reference any behavior
    func getValue(for key: String, in registerID: RegisterID) -> Any? {
        guard let register = self.registers[registerID] as? any BehaviorRegister else {
            return nil
        }
        
        return register.fetchValue(for: key)
    }
    
    /// This method records a behavior for the given key in the specified register.
    ///
    /// In the context of the Mockaffee package, the key is equal to the unique
    /// representation of a function call provided by the underlying `DescriptionProvider`.
    ///
    /// Note that the register has to be a `DefaultBehaviorRegister`, otherwise this
    /// method will return without any effect.
    ///
    /// - Parameters:
    ///     * value: The behavior to be recorded
    ///     * key: The unique key
    ///     * registerID: The register to record the behavior in
    func setValue<T>(_ value: T, for key: String, in registerID: RegisterID) {
        guard let register = self.registers[registerID] as? DefaultBehaviorRegister<T> else {
            return
        }
        
        register.record(value, for: key)
    }
}
