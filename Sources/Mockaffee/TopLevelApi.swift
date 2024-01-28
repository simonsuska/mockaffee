import Foundation

public func verify<T: Mock>(on mock: T, called times: Frequency, _ file: StaticString = #filePath, _ line: UInt = #line) -> T {
    #warning("TODO: Implement")
    return mock
}

public func when<T: Mock>(using mock: T, thenReturn value: Any) -> T {
    #warning("TODO: Implement")
    return mock
}
