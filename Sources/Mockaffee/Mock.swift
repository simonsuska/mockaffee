import Foundation
import XCTest

open class Mock {
    enum Instruction {
        case count
        case verify(Frequency, file: StaticString, line: UInt)
        case `return`(Any)
        case `throw`(Error)
    }
    
    private final let library: Library
    private final var instruction: Instruction
    private final let descriptionProvider: any DescriptionProvider
    
    public init() {
        self.library = Library()
        self.instruction = .count
        self.descriptionProvider = DefaultDescriptionProvider()
    }
    
    private final func verify(
        _ frequency: Frequency,
        for fid: String,
        file: StaticString,
        line: UInt
    ) {
        let fCalls = self.library.getCount(for: fid, in: .functionCallRegister)
        
        XCTAssert(frequency.validate(on: fCalls),
                  "Verification failed. \(fCalls) is not \(frequency.description)",
                  file: file,
                  line: line
        )
    }
    
    private final func count(for fid: String) {
        self.library.increase(for: fid, in: .functionCallRegister)
    }
    
    private final func `return`(_ value: Any, for fid: String) {
        self.library.setValue(value, for: fid, in: .returnBehaviorRegister)
    }
    
    private final func `throw`(_ value: Error, for fid: String) {
        self.library.setValue(value, for: fid, in: .throwBehaviorRegister)
    }
    
    private final func getFHash(from fsignature: String, with values: Any?...) -> String {
        let fString: NSMutableString = NSMutableString(string: fsignature)
        
        values.forEach { value in
            let description = self.descriptionProvider.description(of: value)
            fString.append(description)
        }
        
        return Data(String(fString).utf8).sha1
    }
    
    final func force(to instruction: Instruction) {
        self.instruction = instruction
    }
    
    public final func called(fsignature: String = #function, with values: Any?...) {
        let fhash = self.getFHash(from: fsignature, with: values)
        
        switch self.instruction {
            case .count: self.count(for: fhash)
            case let .verify(frequency, file: file, line: line):
                self.verify(frequency, for: fhash, file: file, line: line)
            case .return(let returnValue): self.return(returnValue, for: fhash)
            case .throw(let error): self.throw(error, for: fhash)
        }
        
        self.instruction = .count
    }
    
    public final func calledReturning(fsignature: String = #function, with values: Any?...) -> Any? {
        let fhash = self.getFHash(from: fsignature, with: values)
        
        switch self.instruction {
            case .count: self.count(for: fhash)
                         return self.library.getValue(for: fhash, in: .returnBehaviorRegister)
            case let .verify(frequency, file: file, line: line):
                self.verify(frequency, for: fhash, file: file, line: line)
            case .return(let returnValue): self.return(returnValue, for: fhash)
            case .throw(let error): self.throw(error, for: fhash)
        }
        
        self.instruction = .count
        return nil
    }
    
    public final func calledThrowing(fsignature: String = #function, with values: Any?...) throws {
        let fhash = self.getFHash(from: fsignature, with: values)
        
        switch self.instruction {
            case .count: self.count(for: fhash)
            if let error = self.library.getValue(for: fhash, in: .throwBehaviorRegister) as? Error {
                throw error
            }
            case let .verify(frequency, file: file, line: line):
                self.verify(frequency, for: fhash, file: file, line: line)
            case .return(let returnValue): self.return(returnValue, for: fhash)
            case .throw(let error): self.throw(error, for: fhash)
        }
        
        self.instruction = .count
    }
    
    public final func calledThrowReturning(fsignature: String = #function, with values: Any?...) throws -> Any? {
        let fhash = self.getFHash(from: fsignature, with: values)
        
        switch self.instruction {
            case .count: self.count(for: fhash)
            if let error = self.library.getValue(for: fhash, in: .throwBehaviorRegister) as? Error {
                throw error
            }
            return self.library.getValue(for: fhash, in: .returnBehaviorRegister)
            case let .verify(frequency, file: file, line: line):
                self.verify(frequency, for: fhash, file: file, line: line)
            case .return(let returnValue): self.return(returnValue, for: fhash)
            case .throw(let error): self.throw(error, for: fhash)
        }
        
        self.instruction = .count
        return nil
    }
}
