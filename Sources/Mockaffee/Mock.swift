import Foundation
import XCTest

/// This type is the base class of every Mockaffee-like mock, from which subclasses
/// inherit the ability to behave as mock objects.
///
/// **Usage**
///
/// To create your custom mock, simply inherit from the `Mock` class. Subsequently you
/// can implement the methods.
///
/// ```swift
/// class SomeMock: Mock {
///     // Implement custom methods
/// }
/// ```
///
/// To be able to verify certain function calls and make use of registered behaviors,
/// you have to call exactly one of the following methods in your method properly.
///
/// - `called(fsignature:with:)`
/// - `calledReturning(fsignature:with:)`
/// - `calledThrowing(fsignature:with:)`
/// - `calledThrowReturning(fsignature:with:)`
///
/// These are provided by the `Mock` class. To learn how to use them correctly, head to
/// the specific documentation of each method.
open class Mock {
    /// This type declares the possible instructions to be executed by the mock object.
    enum Instruction {
        case count
        case verify(Frequency, file: StaticString, line: UInt)
        case `return`(Any)
        case `throw`(Error)
    }
    
    //: MARK: - PROPERTIES
    
    private final let library: Library
    private final var instruction: Instruction
    private final let descriptionProvider: any DescriptionProvider
    
    //: MARK: - INITIALIZER
    
    public init() {
        self.library = Library()
        self.instruction = .count
        self.descriptionProvider = DefaultDescriptionProvider()
    }
    
    //: MARK: - METHODS
    
    /// This method compares the given frequency with the one stored in the library by
    /// using an `XCTAssert`.
    ///
    /// This method will be executed when the instruction has previously been set to
    /// `.verify` by the `verify(on:called:)` function.
    ///
    /// - Parameters:
    ///     * frequency: The frequency to be evaluated
    ///     * fhash: The unique function identifier provided by a `DescriptionProvider`
    ///     * file: The file path in which the verification has been initiated. **This
    ///             parameter must be equal to the value from the `Instruction.verify` case.**
    ///     * line: The line number in which the verification has been initiated. **This
    ///             parameter must be equal to the value from the `Instruction.verify` case.**
    private final func verify(
        _ frequency: Frequency,
        for fhash: String,
        file: StaticString,
        line: UInt
    ) {
        let fCalls = self.library.getCount(for: fhash, in: .functionCallRegister)
        
        XCTAssert(frequency.validate(on: fCalls),
                  "Verification failed. \(fCalls) is not \(frequency.description)",
                  file: file,
                  line: line
        )
    }
    
    /// This method increases the count for the function call with the specified
    /// identifier by 1.
    ///
    /// This method will be executed when the instruction has previously been set to
    /// `.count`. This is the default when none of the following functions have been
    /// called immediately before:
    ///
    /// - `verify(on:called:)`
    /// - `when(using:thenReturn:)`
    /// - `when(using:thenThrow:)`
    ///
    /// - Parameter fhash: The unique function identifier provided by a `DescriptionProvider`
    private final func count(for fhash: String) {
        self.library.increase(for: fhash, in: .functionCallRegister)
    }
    
    /// This method records the given value to be returned for the function call with
    /// the specified identifier.
    ///
    /// This method will be executed when the instruction has previously been set to
    /// `.return` by the `when(using:thenReturn:)` function.
    ///
    /// - Parameters:
    ///     * value: The value to be recorded
    ///     * fhash: The unique function identifier provided by a `DescriptionProvider`
    private final func set(_ value: Any, for fhash: String) {
        self.library.setValue(value, for: fhash, in: .returnBehaviorRegister)
    }
    
    /// This method records the given error to be thrown by the function call with
    /// the specified identifier.
    ///
    /// This method will be executed when the instruction has previously been set to
    /// `.throw` by the `when(using:thenThrow:)` function.
    ///
    /// - Parameters:
    ///     * error: The error to be recorded
    ///     * fhash: The unique function identifier provided by a `DescriptionProvider`
    private final func set(_ error: Error, for fhash: String) {
        self.library.setValue(error, for: fhash, in: .throwBehaviorRegister)
    }
    
    /// This method calculates and returns the unique function identifier for the
    /// given function call.
    ///
    /// - Parameters:
    ///     * fsignature: The signature of the function that has been called
    ///     * values: The parameter values the function has been called with
    /// - Returns: The unique function identifier
    private final func getFHash(from fsignature: String, with values: Any?...) -> String {
        let fString: NSMutableString = NSMutableString(string: fsignature)
        
        values.forEach { value in
            let description = self.descriptionProvider.description(of: value)
            fString.append(description)
        }
        
        return Data(String(fString).utf8).sha1
    }
    
    /// This method causes the instruction to be executed and resets it to `.count`.
    ///
    /// - Parameter fhash: The unique function identifier provided by a `DescriptionProvider`
    /// - Returns: `true`, if the executed instruction was `.count`, otherwise `false`
    private final func executeInstruction(for fhash: String) -> Bool {
        switch self.instruction {
            case .count: self.count(for: fhash)
                         return true
            case let .verify(frequency, file: file, line: line):
                self.verify(frequency, for: fhash, file: file, line: line)
            case .return(let returnValue): self.set(returnValue, for: fhash)
            case .throw(let error): self.set(error, for: fhash)
        }
        
        self.instruction = .count
        return false
    }
    
    /// This method sets the instruction to be executed next.
    ///
    /// It is usually called by one of the following functions:
    ///
    /// - `verify(on:called:)`
    /// - `when(using:thenReturn:)`
    /// - `when(using:thenThrow:)`
    ///
    /// - Parameter instruction: The instruction
    final func force(to instruction: Instruction) {
        self.instruction = instruction
    }
    
    /// This method notifies the mock that a non-throwing, void-returning function has
    /// been called.
    ///
    /// **Usage**
    ///
    /// Call this method within a non-throwing, void-returning method of your mock to track
    /// each method call. In this case, the position where the method call is placed does 
    /// not matter.
    ///
    /// ```swift
    /// class SomeMock: Mock {
    ///     func someMockFunc() {
    ///         // Custom logic
    ///         called()
    ///         // Custom logic
    ///     }
    ///
    ///     func anotherMockFunc(param1: Int, param2: String) {
    ///         // Custom logic
    ///         called(with: param1, param2)
    ///         // Custom logic
    ///     }
    /// }
    /// ```
    ///
    /// - Important: Make sure to forward each parameter! Otherwise, the verification
    ///              mechanism will not work properly.
    /// - Parameters:
    ///     * fsignature: The signature of the function that has been called. **Do not
    ///                   assign this parameter manually, it is determined automatically.**
    ///     * values: The parameter values the function has been called with
    public final func called(fsignature: String = #function, with values: Any?...) {
        let fhash = self.getFHash(from: fsignature, with: values)
        _ = self.executeInstruction(for: fhash)
    }
    
    /// This method notifies the mock that a non-throwing, non-void-returning function has
    /// been called.
    ///
    /// If this method is called in conjunction with any of the following functions, it
    /// returns `nil`, regardless of what is specified:
    ///
    /// - `verify(on:called:)`
    /// - `when(using:thenReturn:)`
    /// - `when(using:thenThrow:)`
    ///
    /// **Usage**
    ///
    /// Call this method within a non-throwing, non-void-returning method of your mock to
    /// track each method call. The result of this method call must be returned from your
    /// method in order to make use of the registered return-behavior.
    ///
    /// Additionally, you have to provide a default return-value which will be used if no
    /// return-behavior is registered or the registered return-behavior is invalid. Since
    /// this method returns `nil` in such cases, simply add the default return-value
    /// behind the nil coalescing operator (`??`).
    ///
    /// ```swift
    /// class SomeMock: Mock {
    ///     @discardableResult
    ///     func someMockFunc() -> Int {
    ///         // Custom logic
    ///         return calledReturning() as? Int ?? 0
    ///     }
    ///
    ///     @discardableResult
    ///     func anotherMockFunc(param1: Int, param2: String) -> Int {
    ///         // Custom logic
    ///         return calledReturning(with: param1, param2) as? Int ?? 0
    ///     }
    /// }
    /// ```
    ///
    /// It is recommended to annotate such methods with `@discardableResult` to suppress
    /// warnings when calling these methods in conjunction with any of the functions
    /// mentioned above.
    ///
    /// - Important: Make sure to forward each parameter! Otherwise, the verification
    ///              mechanism will not work properly.
    /// - Parameters:
    ///     * fsignature: The signature of the function that has been called. **Do not
    ///                   assign this parameter manually, it is determined automatically.**
    ///     * values: The parameter values the function has been called with
    /// - Returns: The value stored in the `.returnBehaviorRegister` of the associated
    ///            library. If the value is not present or the method is called in
    ///            conjunction with any of the functions mentioned below, `nil`.
    public final func calledReturning(
        fsignature: String = #function,
        with values: Any?...
    ) -> Any? {
        let fhash = self.getFHash(from: fsignature, with: values)
        let isCountInstruction = self.executeInstruction(for: fhash)
        
        return isCountInstruction
            ? self.library.getValue(for: fhash, in: .returnBehaviorRegister)
            : nil
    }
    
    /// This method notifies the mock that a throwing, void-returning function has been
    /// called.
    ///
    /// If this method is called in conjunction with any of the following functions, it
    /// throws nothing, regardless of what is specified:
    ///
    /// - `verify(on:called:)`
    /// - `when(using:thenReturn:)`
    /// - `when(using:thenThrow:)`
    ///
    /// **Usage**
    ///
    /// Call this method within a throwing, void-returning method of your mock to track
    /// each method call. In this case, the position where the method call is placed does
    /// not matter.
    ///
    /// ```swift
    /// class SomeMock: Mock {
    ///     func someMockFunc() throws {
    ///         // Custom logic
    ///         try calledThrowing()
    ///         // Custom logic
    ///     }
    ///
    ///     func anotherMockFunc(param1: Int, param2: String) throws {
    ///         // Custom logic
    ///         try calledThrowing(with: param1, param2)
    ///         // Custom logic
    ///     }
    /// }
    /// ```
    ///
    /// - Important: Make sure to forward each parameter! Otherwise, the verification
    ///              mechanism will not work properly.
    /// - Parameters:
    ///     * fsignature: The signature of the function that has been called. **Do not
    ///                   assign this parameter manually, it is determined automatically.**
    ///     * values: The parameter values the function has been called with
    /// - Throws: The error stored in the `.throwBehaviorRegister` of the associated
    ///           library. If an error is not present or the method is called in
    ///           conjunction with any of the functions mentioned above, it throws nothing.
    public final func calledThrowing(
        fsignature: String = #function,
        with values: Any?...
    ) throws {
        let fhash = self.getFHash(from: fsignature, with: values)
        let isCountInstruction = self.executeInstruction(for: fhash)
        
        if isCountInstruction, 
           let error = self.library.getValue(for: fhash,
                                             in: .throwBehaviorRegister) as? Error {
            throw error
        }
    }
    
    /// This method notifies the mock that a throwing, non-void-returning function has
    /// been called.
    ///
    /// If this method is called in conjunction with any of the following functions, it
    /// returns `nil` and throws nothing, regardless of what is specified:
    ///
    /// - `verify(on:called:)`
    /// - `when(using:thenReturn:)`
    /// - `when(using:thenThrow:)`
    ///
    /// **Usage**
    ///
    /// Call this method within a throwing, non-void-returning method of your mock to
    /// track each method call. The result of this method call must be returned from your
    /// method in order to make use of the registered return-behavior.
    ///
    /// Additionally, you have to provide a default return-value which will be used if no
    /// return-behavior is registered or the registered return-behavior is invalid. Since
    /// this method returns `nil` in such cases, simply add the default return-value
    /// behind the nil coalescing operator (`??`).
    ///
    /// ```swift
    /// class SomeMock: Mock {
    ///     @discardableResult
    ///     func someMockFunc() throws -> Int {
    ///         // Custom logic
    ///         return try calledThrowReturning() as? Int ?? 0
    ///     }
    ///
    ///     @discardableResult
    ///     func anotherMockFunc(param1: Int, param2: String) throws -> Int {
    ///         // Custom logic
    ///         return try calledThrowReturning(with: param1, param2) as? Int ?? 0
    ///     }
    /// }
    /// ```
    ///
    /// It is recommended to annotate such methods with `@discardableResult` to suppress
    /// warnings when calling these methods in conjunction with any of the functions
    /// mentioned above.
    ///
    /// - Important: Make sure to forward each parameter! Otherwise, the verification
    ///              mechanism will not work properly.
    /// - Parameters:
    ///     * fsignature: The signature of the function that has been called. **Do not
    ///                   assign this parameter manually, it is determined automatically.**
    ///     * values: The parameter values the function has been called with
    /// - Returns: The value stored in the `.returnBehaviorRegister` of the associated
    ///            library. If the value is not present or the method is called in
    ///            conjunction with any of the functions mentioned below, `nil`.
    /// - Throws: The error stored in the `.throwBehaviorRegister` of the associated
    ///           library. If an error is not present or the method is called in
    ///           conjunction with any of the functions mentioned above, it throws nothing.
    public final func calledThrowReturning(
        fsignature: String = #function,
        with values: Any?...
    ) throws -> Any? {
        let fhash = self.getFHash(from: fsignature, with: values)
        let isCountInstruction = self.executeInstruction(for: fhash)
        
        if isCountInstruction {
            if let error = self.library.getValue(for: fhash,
                                                 in: .throwBehaviorRegister) as? Error {
                throw error
            }
            else {
                return self.library.getValue(for: fhash, in: .returnBehaviorRegister)
            }
        }
        
        return nil
    }
}
