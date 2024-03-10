import Mockaffee

// DP is an abbreviation for DescriptionProvider

enum DPTestEnum {
    case firstValue
    case secondValue(Int)
}

struct DPTestStruct {
    private(set) var value: Int
    init(value: Int) {
        self.value = value
    }
}

struct DPGenericTestStruct<T> {
    private(set) var value: T
    init(value: T) {
        self.value = value
    }
}

class DPTestClass {
    private(set) var value: Int
    init(value: Int) {
        self.value = value
    }
}
