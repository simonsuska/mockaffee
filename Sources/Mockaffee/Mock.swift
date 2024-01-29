import Foundation

open class Mock {
    enum Instruction {
        case count
        case verify(Frequency, file: StaticString, line: UInt)
        case `return`(Any)
    }
    
    private final let library: Library
    private final var instruction: Instruction
    private final let descriptionProvider: any DescriptionProvider
    
    public init() {
        #warning("TODO: Implement")
        self.library = Library()
        self.instruction = .count
        self.descriptionProvider = DefaultDescriptionProvider()
    }
    
    private final func verify(_ frequency: Frequency, for fid: String, file: StaticString, line: UInt) {
        #warning("TODO: Implement")
    }
    
    private final func count(for fid: String) {
        #warning("TODO: Implement")
    }
    
    private final func `return`(_ value: Any, for fid: String) {
        #warning("TODO: Implement")
    }
    
    private final func getFHash(from signature: String, with values: Any?...) -> String {
        #warning("TODO: Implement")
        return ""
    }
    
    final func force(to instruction: Instruction) {
        #warning("TODO: Implement")
    }
    
    public final func called(fsignature: String = #function, with values: Any?...) {
        #warning("TODO: Implement")
    }
    
    public final func calledReturning(fsignature: String = #function, with values: Any?...) -> Any? {
        #warning("TODO: Implement")
        return nil
    }
    
    public final func calledThrowing(fsignature: String = #function, with values: Any?...) throws {
        #warning("TODO: Implement")
    }
    
    public final func calledThrowReturning(fsignature: String = #function, with values: Any?...) throws -> Any? {
        #warning("TODO: Implement")
        return nil
    }
}
