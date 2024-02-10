import Foundation

/// This function creates a `Frequency.atLeast()` instance with the given amount of times.
///
/// It is intended to be used together with the `verify(on:called:_:_:)` function. Note
/// that the amount of times itself is included. Consider the following examples.
///
/// ```swift
/// let frequency = atLeast(4)
///
/// // 3 will evaluate to false, since 3 is not at least 4
/// // 4 will evaluate to true, since 4 is at least 4
/// // 5 will evaluate to true, since 5 is at least 4
/// ```
///
/// - Parameter times: The smallest frequency that is still included
/// - Returns: A `Frequency.atLeast()` instance with the given amount of times
public func atLeast(_ times: UInt) -> Frequency { Frequency.atLeast(times) }

/// This function creates a `Frequency.atMost()` instance with the given amount of times.
///
/// It is intended to be used together with the `verify(on:called:_:_:)` function. Note
/// that the amount of times itself is included. Consider the following examples.
///
/// ```swift
/// let frequency = atMost(4)
///
/// // 3 will evaluate to true, since 3 is at most 4
/// // 4 will evaluate to true, since 4 is at most 4
/// // 5 will evaluate to false, since 5 is not at most 4
/// ```
///
/// - Parameter times: The greatest frequency that is still included
/// - Returns: A `Frequency.atMost()` instance with the given amount of times
public func atMost(_ times: UInt) -> Frequency { Frequency.atMost(times) }

/// This function creates a `Frequency.moreThan()` instance with the given amount of times.
///
/// It is intended to be used together with the `verify(on:called:_:_:)` function. Note
/// that the amount of times itself is not included. Consider the following examples.
///
/// ```swift
/// let frequency = moreThan(4)
///
/// // 3 will evaluate to false, since 3 is not more than 4
/// // 4 will evaluate to false, since 4 is not more than 4
/// // 5 will evaluate to true, since 5 is more than 4
/// ```
///
/// - Parameter times: The greatest frequency that is not included
/// - Returns: A `Frequency.moreThan()` instance with the given amount of times
public func moreThan(_ times: UInt) -> Frequency { Frequency.moreThan(times) }

/// This function creates a `Frequency.lessThan()` instance with the given amount of times.
///
/// It is intended to be used together with the `verify(on:called:_:_:)` function. Note
/// that the amount of times itself is not included. Consider the following examples.
///
/// ```swift
/// let frequency = lessThan(4)
///
/// // 3 will evaluate to true, since 3 is less than 4
/// // 4 will evaluate to false, since 4 is not less than 4
/// // 5 will evaluate to false, since 5 is not less than 4
/// ```
///
/// - Parameter times: The smallest frequency that is not included
/// - Returns: A `Frequency.lessThan()` instance with the given amount of times
public func lessThan(_ times: UInt) -> Frequency { Frequency.lessThan(times) }

/// This function creates a `Frequency.exactly()` instance with the given amount of times.
///
/// It is intended to be used together with the `verify(on:called:_:_:)` function.
/// Consider the following examples.
///
/// ```swift
/// let frequency = exactly(4)
///
/// // 3 will evaluate to false, since 3 is not exactly 4
/// // 4 will evaluate to true, since 4 is exactly 4
/// // 5 will evaluate to false, since 5 is not exactly 4
/// ```
///
/// - Parameter times: The only frequency that will evaluate to `true`
/// - Returns: A `Frequency.exactly()` instance with the given amount of times
public func exactly(_ times: UInt) -> Frequency { Frequency.exactly(times) }

/// This function creates a `Frequency.exactly(0)` instance with the given amount of times.
///
/// It is intended to be used together with the `verify(on:called:_:_:)` function.
///
/// - Returns: A `Frequency.exactly(0)` instance with the given amount of times
public func never() -> Frequency { Frequency.exactly(0) }

/// This type declares the possible frequencies provided by the API.
///
/// In the context of the Mockaffee package, it is used to verify the amount of
/// certain function calls.
///
/// You should not create an instance of this type on your own. Use the top-level
/// function of the same name instead. For example, use `atLeast(4)` to create a
/// `Frequency.atLeast(4)` instance.
public enum Frequency {
    case atLeast(UInt)
    case atMost(UInt)
    case moreThan(UInt)
    case lessThan(UInt)
    case exactly(UInt)
    
    /// This property provides a textual representation of the condition along with the
    /// given frequency.
    var description: String {
        switch self {
            case .atLeast(let times): "at least \(times)"
            case .atMost(let times): "at most \(times)"
            case .moreThan(let times): "more than \(times)"
            case .lessThan(let times): "less than \(times)"
            case .exactly(let times): "exactly \(times)"
        }
    }
    
    /// This method compares the given value with the required frequency.
    ///
    /// - Parameter value: The frequency to be evaluated
    /// - Returns: `true` if the given frequency meets the condition, otherwise `false`
    func validate(on value: UInt) -> Bool {
        return switch self {
            case .atLeast(let times): value >= times
            case .atMost(let times): value <= times
            case .moreThan(let times): value > times
            case .lessThan(let times): value < times
            case .exactly(let times): value == times
        }
    }
}
