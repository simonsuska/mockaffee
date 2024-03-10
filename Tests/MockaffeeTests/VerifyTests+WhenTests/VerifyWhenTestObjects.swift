import Mockaffee

class TestMock: Mock {
    func withoutParams() {
        called()
    }
    
    func withSingleParam<T>(_ param: T) {
        called(with: param)
    }
    
    func withVariadicParam<T>(_ param: T...) {
        called(with: param)
    }
    
    func withMultipleParams<T, V>(_ param1: T, _ param2: V) {
        called(with: param1, param2)
    }
    
    @discardableResult
    func withReturnValue<T>(_ param: T) -> T {
        calledReturning(with: param) as? T ?? param
    }
    
    func withThrowing<T>(_ param: T) throws {
        try calledThrowing(with: param)
    }
    
    @discardableResult
    func withThrowReturning<T>(_ param: T) throws -> T {
        try calledThrowReturning(with: param) as? T ?? param
    }
}

enum TestEnum {
    case firstValue
    case secondValue(Int)
}

enum AnotherTestEnum {
    case firstValue
}

struct TestStruct<T> {
    private(set) var value: T
    init(value: T) {
        self.value = value
    }
}

class TestClass<T>: Equatable {
    static func == (lhs: TestClass<T>, rhs: TestClass<T>) -> Bool {
        UInt(bitPattern: ObjectIdentifier(lhs)) == UInt(bitPattern: ObjectIdentifier(rhs))
    }
    
    private(set) var value: T
    init(value: T) {
        self.value = value
    }
}

enum TestError: Error {
    case firstException
}
