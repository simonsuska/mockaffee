import Foundation

/// This function initiates the verification on the given mock object.
///
/// All parameters that are passed when calling the subsequent function are taken into
/// account. Therefore, it is important to pass meaningful parameters. The kind of
/// parameter determines whether two function calls are regarded equal or not.
///
/// The following examples provide an overview of the behavior of the
/// `verify(on:called:_:_:)` function with different kinds of parameters.
///
/// **General behavior**
///
/// ```swift
/// // Asserts that `someFunction()` has never been called on 
/// // `someMock`.
/// verify(on: someMock, called: never()).someFunction()
///
/// // Asserts that `someFunction(_ param: Double)` has been 
/// // called exactly twice with the value of 17.4 on `someMock`.
/// verify(on: someMock, called: exactly(2)).someFunction(17.4)
/// ```
/// **Behavior with value-typed parameters**
///
/// As usual, for value-typed parameters only the value itself is evaluated, but not
/// the reference. This applies to all enums and structs, no matter if built-in or custom.
///
/// ```swift
/// let someStruct = SomeStruct(someVar: 203)
/// let anotherStruct = SomeStruct(someVar: 203)
///
/// // Function call on mock object
/// someMock.someFunction(someStruct)
///
/// // Assertion will be successful
/// verify(on: someMock, called: exactly(1)).someFunction(anotherStruct)
/// ```
///
/// **Behavior with reference-typed parameters**
///
/// As usual, for reference-typed parameters only the reference itself is evaluated, but
/// not the value. This applies to all classes, no matter if built-in or custom.
///
/// ```swift
/// let someClass = SomeClass(someVar: 203)
/// let anotherClass = SomeClass(someVar: 203)
///
/// // Function call on mock object
/// someMock.someFunction(someClass)
///
/// // Assertion will fail
/// verify(on: someMock, called: exactly(1)).someFunction(anotherClass)
/// ```
///
/// **Behavior with collections**
///
/// Types that store multiple values are divided into two groups:
///
/// - Ordered collections: `Array` and `Tuple`
/// - Unordered collections: `Set` and `Dictionary`
///
/// For ordered types the order passed is important, while for unordered types it does
/// not matter.
///
/// ```swift
/// let someArray = [174, 203, 403]
/// let anotherArray = [203, 174, 403]
///
/// let someSet: Set<Int> = [174, 203, 403]
/// let anotherSet: Set<Int> = [203, 174, 403]
///
/// // Function calls on mock object
/// someMock.someFunction(someArray)
/// someMock.someFunction(someSet)
///
/// // Assertion will fail
/// verify(on: someMock, called: exactly(1)).someFunction(anotherArray)
///
/// // Assertion will be successful
/// verify(on: someMock, called: exactly(1)).someFunction(anotherSet)
/// ```
///
/// - Parameters:
///     * mock: The mock object
///     * times: The amount of times the subsequent method should have been called on the
///              mock object
///     * file: The file path in which the verification has been initiated. **Do not
///             assign this parameter manually, it is determined automatically.**
///     * line: The line number in which the verification has been initiated. **Do not
///             assign this parameter manually, it is determined automatically.**
/// - Returns: The mock object itself
public func verify<T: Mock>(
    on mock: T,
    called times: Frequency,
    // The file and line parameters are provided to indicate a possbile assertion error
    // at the point where this function has been called.
    _ file: StaticString = #filePath,
    _ line: UInt = #line
) -> T {
    mock.force(to: .verify(times, file: file, line: line))
    return mock
}

/// This function initiates the recording of a return value on the given mock object.
///
/// All parameters that are passed when calling the subsequent function are taken into
/// account. Therefore, it is important to pass meaningful parameters. The kind of
/// parameter determines whether two function calls are regarded equal or not.
///
/// The following examples provide an overview of the behavior of the
/// `when(using:thenReturn:)` function with different kinds of parameters.
///
/// **General behavior**
///
/// ```swift
/// // `someFunction()` will return 203 when called on `someMock`
/// when(using: someMock, thenReturn: 203).someFunction()
///
/// // `someFunction(_ param: Double)` will return 203 when 
/// // called with the value of 17.4 on `someMock`. When called
/// // with other values, it will return the default value.
/// when(using: someMock, thenReturn: 203).someFunction(17.4)
/// ```
/// **Behavior with value-typed parameters**
///
/// As usual, for value-typed parameters only the value itself is evaluated, but not
/// the reference. This applies to all enums and structs, no matter if built-in or custom.
///
/// ```swift
/// let someStruct = SomeStruct(someVar: 203)
/// let anotherStruct = SomeStruct(someVar: 203)
///
/// when(using: someMock, thenReturn: 174).someFunction(someStruct)
///
/// // Function call on mock object will return 174
/// someMock.someFunction(anotherStruct)
/// ```
///
/// **Behavior with reference-typed parameters**
///
/// As usual, for reference-typed parameters only the reference itself is evaluated, but
/// not the value. This applies to all classes, no matter if built-in or custom.
///
/// ```swift
/// let someClass = SomeClass(someVar: 203)
/// let anotherClass = SomeClass(someVar: 203)
///
/// when(using: someMock, thenReturn: 174).someFunction(someClass)
///
/// // Function call on mock object will not return 174, 
/// // but the default value
/// someMock.someFunction(anotherClass)
/// ```
///
/// **Behavior with collections**
///
/// Types that store multiple values are divided into two groups:
///
/// - Ordered collections: `Array` and `Tuple`
/// - Unordered collections: `Set` and `Dictionary`
///
/// For ordered types the order passed is important, while for unordered types it does
/// not matter.
///
/// ```swift
/// let someArray = [174, 203, 403]
/// let anotherArray = [203, 174, 403]
///
/// let someSet: Set<Int> = [174, 203, 403]
/// let anotherSet: Set<Int> = [203, 174, 403]
///
/// when(using: someMock, thenReturn: 174).someFunction(someArray)
/// when(using: someMock, thenReturn: 174).someFunction(someSet)
///
/// // Function call on mock object will not return 174, 
/// // but the default value
/// someMock.someFunction(anotherArray)
///
/// // Function call on mock object will return 174
/// someMock.someFunction(anotherSet)
/// ```
///
/// When applying the `when(using:thenReturn:)` function on non-returning functions,
/// it does not have any effect.
///
/// - Parameters:
///     * mock: The mock object
///     * value: The value the subsequent method should return when called on the
///              mock object
/// - Returns: The mock object itself
public func when<T: Mock>(using mock: T, thenReturn value: Any) -> T {
    mock.force(to: .return(value))
    return mock
}

/// This function initiates the recording of an error on the given mock object.
///
/// All parameters that are passed when calling the subsequent function are taken into
/// account. Therefore, it is important to pass meaningful parameters. The kind of
/// parameter determines whether two function calls are regarded equal or not.
///
/// The following examples provide an overview of the behavior of the
/// `when(using:thenThrow:)` function with different kinds of parameters.
///
/// **General behavior**
///
/// ```swift
/// // `someFunction()` will throw `SomeError.xerr` when
/// // called on `someMock`
/// try when(using: someMock, thenThrow: SomeError.xerr).someFunction()
///
/// // `someFunction(_ param: Double)` will throw 
/// // `SomeError.xerr` when called with the value of
/// // 17.4 on `someMock`. When called with other values, it
/// // will not throw an error.
/// try when(using: someMock, thenThrow: SomeError.xerr).someFunction(17.4)
/// ```
/// **Behavior with value-typed parameters**
///
/// As usual, for value-typed parameters only the value itself is evaluated, but not
/// the reference. This applies to all enums and structs, no matter if built-in or custom.
///
/// ```swift
/// let someStruct = SomeStruct(someVar: 203)
/// let anotherStruct = SomeStruct(someVar: 203)
///
/// try when(using: someMock, thenThrow: SomeError.xerr).someFunction(someStruct)
///
/// // Function call on mock object will throw `SomeError.xerr`
/// try someMock.someFunction(anotherStruct)
/// ```
///
/// **Behavior with reference-typed parameters**
///
/// As usual, for reference-typed parameters only the reference itself is evaluated, but
/// not the value. This applies to all classes, no matter if built-in or custom.
///
/// ```swift
/// let someClass = SomeClass(someVar: 203)
/// let anotherClass = SomeClass(someVar: 203)
///
/// try when(using: someMock, thenThrow: SomeError.xerr).someFunction(someClass)
///
/// // Function call on mock object will not throw 
/// // `SomeError.xerr`
/// try someMock.someFunction(anotherClass)
/// ```
///
/// **Behavior with collections**
///
/// Types that store multiple values are divided into two groups:
///
/// - Ordered collections: `Array` and `Tuple`
/// - Unordered collections: `Set` and `Dictionary`
///
/// For ordered types the order passed is important, while for unordered types it does
/// not matter.
///
/// ```swift
/// let someArray = [174, 203, 403]
/// let anotherArray = [203, 174, 403]
///
/// let someSet: Set<Int> = [174, 203, 403]
/// let anotherSet: Set<Int> = [203, 174, 403]
///
/// try when(using: someMock, thenThrow: SomeError.xerr).someFunction(someArray)
/// try when(using: someMock, thenThrow: SomeError.xerr).someFunction(someSet)
///
/// // Function call on mock object will not throw,
/// // `SomeError.xerr`
/// try someMock.someFunction(anotherArray)
///
/// // Function call on mock object will throw `SomeError.xerr`
/// try someMock.someFunction(anotherSet)
/// ```
///
/// When applying the `when(using:thenThrow:)` function on non-throwing functions,
/// it does not have any effect.
///
/// - Parameters:
///     * mock: The mock object
///     * error: The error the subsequent method should throw when called on the
///              mock object
/// - Returns: The mock object itself
public func when<T: Mock>(using mock: T, thenThrow error: Error) -> T {
    mock.force(to: .throw(error))
    return mock
}
