import XCTest
@testable import Mockaffee

final class FrequencyTests: XCTestCase {
    /// This test evaluates whether the validation behaves
    /// properly in case of `Frequency.atLeast`.
    func testAtLeast() {
        let frequency = atLeast(3)
        
        XCTAssertTrue(frequency.validate(on: 3))
        XCTAssertTrue(frequency.validate(on: 4))
        XCTAssertFalse(frequency.validate(on: 2))
    }
    
    /// This test evaluates whether the validation behaves
    /// properly in case of `Frequency.atMost`.
    func testAtMost() {
        let frequency = atMost(3)
        
        XCTAssertTrue(frequency.validate(on: 3))
        XCTAssertTrue(frequency.validate(on: 2))
        XCTAssertFalse(frequency.validate(on: 4))
    }
    
    /// This test evaluates whether the validation behaves
    /// properly in case of `Frequency.moreThan`.
    func testMoreThan() {
        let frequency = moreThan(3)
        
        XCTAssertTrue(frequency.validate(on: 4))
        XCTAssertFalse(frequency.validate(on: 3))
        XCTAssertFalse(frequency.validate(on: 2))
    }
    
    /// This test evaluates whether the validation behaves
    /// properly in case of `Frequency.lessThan`.
    func testLessThan() {
        let frequency = lessThan(3)
        
        XCTAssertTrue(frequency.validate(on: 2))
        XCTAssertFalse(frequency.validate(on: 3))
        XCTAssertFalse(frequency.validate(on: 4))
    }
    
    /// This test evaluates whether the validation behaves
    /// properly in case of `Frequency.exactly`.
    func testExactly() {
        let frequency = exactly(3)
        
        XCTAssertTrue(frequency.validate(on: 3))
        XCTAssertFalse(frequency.validate(on: 2))
        XCTAssertFalse(frequency.validate(on: 4))
    }
    
    /// This test evaluates whether the validation behaves
    /// properly in case of `Frequency.never`.
    func testNever() {
        let frequency = never()
        
        XCTAssertTrue(frequency.validate(on: 0))
        XCTAssertFalse(frequency.validate(on: 1))
    }
}
