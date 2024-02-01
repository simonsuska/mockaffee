import Foundation

public func verify<T: Mock>(
    on mock: T,
    called times: Frequency,
    _ file: StaticString = #filePath,
    _ line: UInt = #line
) -> T {
    mock.force(to: .verify(times, file: file, line: line))
    return mock
}
 
public func when<T: Mock>(using mock: T, thenReturn value: Any) -> T {
    mock.force(to: .return(value))
    return mock
}

public func when<T: Mock>(using mock: T, thenThrow error: Error) -> T {
    mock.force(to: .throw(error))
    return mock
}
