import XCTest
@testable import Mockaffee

final class WhenTests: XCTestCase {
    private var testMock: TestMock!
    
    override func setUp() {
        self.testMock = TestMock()
    }
    
    /// This test evaluates whether the `when(using:thenReturn:)` function
    /// behaves properly for methods with a value-typed return value.
    func testReturnValueType() {
        var returnValue = testMock.withReturnValue(174)
        XCTAssertEqual(returnValue, 174)
        
        when(using: testMock, thenReturn: "A").withReturnValue(174)
        returnValue = testMock.withReturnValue(174)
        XCTAssertEqual(returnValue, 174)
        
        when(using: testMock, thenReturn: 203).withReturnValue(174)
        returnValue = testMock.withReturnValue(174)
        XCTAssertEqual(returnValue, 203)
        
        returnValue = testMock.withReturnValue(403)
        XCTAssertEqual(returnValue, 403)
    }
    
    /// This test evaluates whether the `when(using:thenReturn:)` function
    /// behaves properly for methods with a reference-typed return value.
    func testReturnReferenceType() {
        let testClass = TestClass(value: 174)
        let anotherTestClass = TestClass(value: 174)
        let yetAnotherTestClass = TestClass(value: 174)
        
        var returnValue = testMock.withReturnValue(testClass)
        XCTAssertEqual(returnValue, testClass)
        XCTAssertNotEqual(returnValue, anotherTestClass)
        XCTAssertNotEqual(returnValue, yetAnotherTestClass)
        
        when(using: testMock, thenReturn: "A").withReturnValue(testClass)
        returnValue = testMock.withReturnValue(testClass)
        XCTAssertEqual(returnValue, testClass)
        XCTAssertNotEqual(returnValue, anotherTestClass)
        XCTAssertNotEqual(returnValue, yetAnotherTestClass)
        
        when(using: testMock, thenReturn: anotherTestClass).withReturnValue(testClass)
        returnValue = testMock.withReturnValue(testClass)
        XCTAssertNotEqual(returnValue, testClass)
        XCTAssertEqual(returnValue, anotherTestClass)
        XCTAssertNotEqual(returnValue, yetAnotherTestClass)
        
        returnValue = testMock.withReturnValue(yetAnotherTestClass)
        XCTAssertNotEqual(returnValue, testClass)
        XCTAssertNotEqual(returnValue, anotherTestClass)
        XCTAssertEqual(returnValue, yetAnotherTestClass)
    }
    
    /// This test evaluates whether the `when(using:thenThrow:)` 
    /// function behaves properly.
    func testThrow() throws {
        XCTAssertNoThrow( try testMock.withThrowing(174) )
        
        try when(using: testMock, thenThrow: TestError.firstException).withThrowing(174)
        XCTAssertThrowsError( try testMock.withThrowing(174) ) { error in
            if let error = error as? TestError {
                XCTAssert(error == TestError.firstException)
            }
        }
        XCTAssertNoThrow( try testMock.withThrowing(203) )
    }
    
    /// This test evaluates whether the `when(using:thenReturn:)` and
    /// `when(using:thenThrow:)` functions behave properly in correlation.
    func testThrowReturning() throws {
        XCTAssertNoThrow( try testMock.withThrowReturning(174) )
        var returnValue = try testMock.withThrowReturning(174)
        XCTAssertEqual(returnValue, 174)
        
        try when(using: testMock, thenReturn: "A").withThrowReturning(174)
        XCTAssertNoThrow( try testMock.withThrowReturning(174) )
        returnValue = try testMock.withThrowReturning(174)
        XCTAssertEqual(returnValue, 174)
        
        try when(using: testMock, thenReturn: 203).withThrowReturning(174)
        XCTAssertNoThrow( try testMock.withThrowReturning(174) )
        returnValue = try testMock.withThrowReturning(174)
        XCTAssertEqual(returnValue, 203)
        
        XCTAssertNoThrow( try testMock.withThrowReturning(403) )
        returnValue = try testMock.withThrowReturning(403)
        XCTAssertEqual(returnValue, 403)
        
        try when(using: testMock, thenThrow: TestError.firstException).withThrowReturning(174)
        XCTAssertThrowsError( try testMock.withThrowReturning(174) ) { error in
            if let error = error as? TestError {
                XCTAssert(error == TestError.firstException)
            }
        }
        XCTAssertNoThrow( try testMock.withThrowReturning(203) )
    }
}
