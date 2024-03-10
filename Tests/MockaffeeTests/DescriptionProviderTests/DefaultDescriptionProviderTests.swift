import XCTest
@testable import Mockaffee

final class DefaultDescriptionProviderTests: XCTestCase {
    private var descriptionProvider: DefaultDescriptionProvider!
    
    override func setUp() {
        self.descriptionProvider = DefaultDescriptionProvider()
    }
    
    /// This test evaluates whether the `description(of:)` method behaves properly for `nil`.
    func testDescriptionOfNil() {
        let description = self.descriptionProvider.description(of: nil)
        XCTAssertEqual(description, "nil#")
    }
    
    /// This test evaluates whether the `description(of:)` method behaves properly for primitive
    /// value-typed parameters, e.g. Int, Double, Float.
    func testDescriptionOfPrimitive() {
        let description = self.descriptionProvider.description(of: 174)
        XCTAssertEqual(description, "174*Int#")
    }
    
    /// This test evaluates whether the `description(of:)` method behaves properly for enums.
    func testDescriptionOfEnum() {
        var description = self.descriptionProvider.description(of: DPTestEnum.firstValue)
        XCTAssertEqual(description, "firstValue*DPTestEnum#")
        
        description = self.descriptionProvider.description(of: DPTestEnum.secondValue(174))
        XCTAssertEqual(description, "secondValue(174)*DPTestEnum#")
    }
    
    /// This test evaluates whether the `description(of:)` method behaves properly for structs.
    func testDescriptionOfStruct() {
        var description = self.descriptionProvider.description(of: DPTestStruct(value: 174))
        XCTAssertEqual(description, "DPTestStruct(value: 174)*DPTestStruct#")
        
        description = self.descriptionProvider.description(of: DPGenericTestStruct(value: 203))
        XCTAssertEqual(description, "DPGenericTestStruct<Int>(value: 203)*DPGenericTestStruct<Int>#")
    }
    
    /// This test evaluates whether the `description(of:)` method behaves properly for reference types.
    func testDescriptionOfReferenceType() {
        let testClass = DPTestClass(value: 174)
        let description = self.descriptionProvider.description(of: testClass)
        XCTAssertEqual(description,
                       "\(String(UInt(bitPattern: ObjectIdentifier(testClass))))*DPTestClass#")
    }
    
    /// This test evaluates whether the `description(of:)` method behaves properly for ordered collections.
    func testDescriptionOfOrderedCollection() {
        var description = self.descriptionProvider.description(of: [174, 203])
        XCTAssertEqual(description, "[174, 203]*Array<Int>#")
        
        description = self.descriptionProvider.description(of: (174, "April"))
        XCTAssertEqual(description, "(174, \"April\")*(Int, String)#")
    }
    
    /// This test evaluates whether the `description(of:)` method behaves properly for sets.
    func testDescriptionOfSet() {
        let expectedDescription = "[AnyHashable(174), AnyHashable(203), " +
                                  "AnyHashable(21), AnyHashable(403)]*Set<Int>#"
        
        var someSet: Set<Int> = [403, 174, 203, 21]
        var description = self.descriptionProvider.description(of: someSet)
        XCTAssertEqual(description, expectedDescription)
        
        someSet = [203, 174, 21, 403]
        description = self.descriptionProvider.description(of: someSet)
        XCTAssertEqual(description, expectedDescription)
        
        someSet = [174, 203, 174, 21, 203, 403]
        description = self.descriptionProvider.description(of: someSet)
        XCTAssertEqual(description, expectedDescription)
    }
    
    /// This test evaluates whether the `description(of:)` method behaves properly for dictionaries.
    func testDescriptionOfDictionary() {
        let expectedDescription = "[(key: AnyHashable(1), value: \"A\"), " +
                                  "(key: AnyHashable(2), value: \"B\"), " +
                                  "(key: AnyHashable(3), value: \"C\"), " +
                                  "(key: AnyHashable(4), value: \"D\")]*Dictionary<Int, String>#"
        
        var someDict = [1: "A", 2: "B", 3: "C", 4: "D"]
        var description = self.descriptionProvider.description(of: someDict)
        XCTAssertEqual(description, expectedDescription)
        
        someDict = [3: "C", 1: "A", 4: "D", 2: "B"]
        description = self.descriptionProvider.description(of: someDict)
        XCTAssertEqual(description, expectedDescription)
    }
}
