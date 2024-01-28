import Foundation

protocol Register {
    associatedtype Value
    func fetchValue(for key: String) -> Value?
}
