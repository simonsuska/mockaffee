import Foundation

public func atLeast(_ times: UInt) -> Frequency { Frequency.atLeast(times) }
public func atMost(_ times: UInt) -> Frequency { Frequency.atMost(times) }
public func moreThan(_ times: UInt) -> Frequency { Frequency.moreThan(times) }
public func lessThan(_ times: UInt) -> Frequency { Frequency.lessThan(times) }
public func exactly(_ times: UInt) -> Frequency { Frequency.exactly(times) }
public func never() -> Frequency { Frequency.exactly(0) }

public enum Frequency {
    case atLeast(UInt)
    case atMost(UInt)
    case moreThan(UInt)
    case lessThan(UInt)
    case exactly(UInt)
    
    func validate(on value: UInt) -> Bool {
        #warning("TODO: Implement")
        return false
    }
}
