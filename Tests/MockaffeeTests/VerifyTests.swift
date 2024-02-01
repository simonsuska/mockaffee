import XCTest
@testable import Mockaffee

final class VerifyTests: XCTestCase {
    private var testMock: TestMock!
    
    override func setUp() {
        self.testMock = TestMock()
    }
    
    /// This test evaluates whether the `verify(on:called:)` function
    /// behaves properly for methods without parameters.
    func testVerifyWithoutParams() {
        verify(on: testMock, called: never()).withoutParams()
        
        testMock.withoutParams()
        verify(on: testMock, called: exactly(1)).withoutParams()
        
        testMock.withoutParams()
        verify(on: testMock, called: exactly(2)).withoutParams()
    }
    
    /// This test evaluates whether the `verify(on:called:)` function behaves properly
    /// for methods with a primitive value-typed parameter, e.g. Int, Double, Float.
    func testVerifyWithPrimitiveParam() {
        verify(on: testMock, called: never()).withSingleParam(17.4)
        
        testMock.withSingleParam(17.4)
        verify(on: testMock, called: exactly(1)).withSingleParam(17.4)
        
        testMock.withSingleParam(17.4)
        verify(on: testMock, called: exactly(2)).withSingleParam(17.4)
    }
    
    /// This test evaluates whether the `verify(on:called:)` function behaves properly
    /// for methods with an ordered value-typed parameter, e.g. Array and Tuple.
    func testVerifyWithOrderedParam() {
        verify(on: testMock, called: never()).withSingleParam(["A", "B", "C"])
        
        testMock.withSingleParam(["A", "B", "C"])
        verify(on: testMock, called: exactly(1)).withSingleParam(["A", "B", "C"])
        
        testMock.withSingleParam(["A", "B", "C"])
        verify(on: testMock, called: exactly(2)).withSingleParam(["A", "B", "C"])
    }
    
    /// This test evaluates whether the `verify(on:called:)` function 
    /// behaves properly for methods with a parameter of type Set.
    func testVerifyWithSetParam() {
        let testSet: Set<String> = ["A", "B", "C"]
        let anotherTestSet: Set<String> = ["A", "C", "B"]
        
        verify(on: testMock, called: never()).withSingleParam(testSet)
        verify(on: testMock, called: never()).withSingleParam(anotherTestSet)
        
        testMock.withSingleParam(testSet)
        verify(on: testMock, called: exactly(1)).withSingleParam(testSet)
        verify(on: testMock, called: exactly(1)).withSingleParam(anotherTestSet)
        
        testMock.withSingleParam(anotherTestSet)
        verify(on: testMock, called: exactly(2)).withSingleParam(testSet)
        verify(on: testMock, called: exactly(2)).withSingleParam(anotherTestSet)
    }
    
    /// This test evaluates whether the `verify(on:called:)` function
    /// behaves properly for methods with a parameter of type Dictionary.
    func testVerifyWithDictionaryParam() {
        let testDict = [1: "A", 2: "B", 3: "C"]
        let anotherTestDict = [1: "A", 3: "C", 2: "B"]
        
        verify(on: testMock, called: never()).withSingleParam(testDict)
        verify(on: testMock, called: never()).withSingleParam(anotherTestDict)
        
        testMock.withSingleParam(testDict)
        verify(on: testMock, called: exactly(1)).withSingleParam(testDict)
        verify(on: testMock, called: exactly(1)).withSingleParam(anotherTestDict)
        
        testMock.withSingleParam(anotherTestDict)
        verify(on: testMock, called: exactly(2)).withSingleParam(testDict)
        verify(on: testMock, called: exactly(2)).withSingleParam(anotherTestDict)
    }
    
    /// This test evaluates whether the `verify(on:called:)` function behaves properly
    /// for methods with a parameter of an enum, especially custom ones.
    func testVerifyWithEnumParam() {
        verify(on: testMock, called: never()).withSingleParam(TestEnum.firstValue)
        verify(on: testMock, called: never()).withSingleParam(AnotherTestEnum.firstValue)
        
        testMock.withSingleParam(TestEnum.firstValue)
        verify(on: testMock, called: exactly(1)).withSingleParam(TestEnum.firstValue)
        verify(on: testMock, called: never()).withSingleParam(AnotherTestEnum.firstValue)
        
        verify(on: testMock, called: never()).withSingleParam(TestEnum.secondValue(1))
        verify(on: testMock, called: never()).withSingleParam(TestEnum.secondValue(2))
        
        testMock.withSingleParam(TestEnum.secondValue(1))
        verify(on: testMock, called: exactly(1)).withSingleParam(TestEnum.secondValue(1))
        verify(on: testMock, called: never()).withSingleParam(TestEnum.secondValue(2))
    }
    
    /// This test evaluates whether the `verify(on:called:)` function behaves properly
    /// for methods with a parameter of a struct, especially custom ones.
    func testVerifyWithStructParam() {
        verify(on: testMock, called: never()).withSingleParam(TestStruct(value: 17.4))
        
        testMock.withSingleParam(TestStruct(value: 17.4))
        verify(on: testMock, called: exactly(1)).withSingleParam(TestStruct(value: 17.4))
        
        testMock.withSingleParam(TestStruct(value: 17.4))
        verify(on: testMock, called: exactly(2)).withSingleParam(TestStruct(value: 17.4))
    }
    
    /// This test evaluates whether the `verify(on:called:)` function 
    /// behaves properly for methods with a reference-typed parameter.
    func testVerifyWithReferenceTypedParam() {
        let testClass = TestClass(value: 17.4)
        let anotherTestClass = TestClass(value: 17.4)
        
        verify(on: testMock, called: never()).withSingleParam(testClass)
        verify(on: testMock, called: never()).withSingleParam(anotherTestClass)
        
        testMock.withSingleParam(testClass)
        verify(on: testMock, called: exactly(1)).withSingleParam(testClass)
        verify(on: testMock, called: never()).withSingleParam(anotherTestClass)
        
        testMock.withSingleParam(anotherTestClass)
        verify(on: testMock, called: exactly(1)).withSingleParam(testClass)
        verify(on: testMock, called: exactly(1)).withSingleParam(anotherTestClass)
    }
    
    /// This test evaluates whether the `verify(on:called:)` function 
    /// behaves properly for methods with a variadic parameter.
    func testVerifyWithVariadicParam() {
        verify(on: testMock, called: never()).withVariadicParam("A", "B", "C")
        
        testMock.withVariadicParam("A", "B", "C")
        verify(on: testMock, called: exactly(1)).withVariadicParam("A", "B", "C")
        verify(on: testMock, called: never()).withVariadicParam("A", "C", "B")
        
        testMock.withVariadicParam("A", "B", "C")
        verify(on: testMock, called: exactly(2)).withVariadicParam("A", "B", "C")
        verify(on: testMock, called: never()).withVariadicParam("A", "C", "B")
    }
    
    /// This test evaluates whether the `verify(on:called:)` function
    /// behaves properly for methods with multiple parameters.
    func testVerifyWithMultipleParams() {
        verify(on: testMock, called: never()).withMultipleParams(17.4, "A")
        
        testMock.withMultipleParams(17.4, "A")
        verify(on: testMock, called: exactly(1)).withMultipleParams(17.4, "A")
        verify(on: testMock, called: never()).withMultipleParams("A", 17.4)
        
        testMock.withMultipleParams(17.4, "A")
        verify(on: testMock, called: exactly(2)).withMultipleParams(17.4, "A")
        verify(on: testMock, called: never()).withMultipleParams("A", 17.4)
    }
    
    /// This test evaluates whether the `verify(on:called:)` function behaves 
    /// properly for methods with equal parameter values of different types.
    func testVerifyWithEqualNumbers() {
        verify(on: testMock, called: never()).withSingleParam(Float(1.74))
        verify(on: testMock, called: never()).withSingleParam(1.74)
        
        testMock.withSingleParam(Float(1.74))
        verify(on: testMock, called: exactly(1)).withSingleParam(Float(1.74))
        verify(on: testMock, called: never()).withSingleParam(1.74)
        
        testMock.withSingleParam(1.74)
        verify(on: testMock, called: exactly(1)).withSingleParam(Float(1.74))
        verify(on: testMock, called: exactly(1)).withSingleParam(1.74)
    }
    
    /// This test evaluates whether the `verify(on:called:)` function 
    /// behaves properly for methods with a return value.
    func testVerifyReturning() {
        verify(on: testMock, called: never()).withReturnValue(174)
        
        testMock.withReturnValue(174)
        verify(on: testMock, called: exactly(1)).withReturnValue(174)
        
        testMock.withReturnValue(174)
        verify(on: testMock, called: exactly(2)).withReturnValue(174)
    }
    
    /// This test evaluates whether the `verify(on:called:)` function 
    /// behaves properly for throwing methods.
    func testVerifyThrowing() throws {
        try verify(on: testMock, called: never()).withThrowing(17.4)
        
        try testMock.withThrowing(17.4)
        try verify(on: testMock, called: exactly(1)).withThrowing(17.4)
        
        try testMock.withThrowing(17.4)
        try verify(on: testMock, called: exactly(2)).withThrowing(17.4)
    }
    
    /// This test evaluates whether the `verify(on:called:)` function 
    /// behaves properly for throwing methods with a return value.
    func testVerifyThrowReturning() throws {
        try verify(on: testMock, called: never()).withThrowReturning(17.4)
        
        try testMock.withThrowReturning(17.4)
        try verify(on: testMock, called: exactly(1)).withThrowReturning(17.4)
        
        try testMock.withThrowReturning(17.4)
        try verify(on: testMock, called: exactly(2)).withThrowReturning(17.4)
    }
}
