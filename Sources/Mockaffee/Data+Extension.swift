import Foundation
import CommonCrypto

extension Data {
    /// An extension property that calculates the sha1 value from the underlying
    /// `Data` object and returns it in a 40-sign hexadecimal representation.
    ///
    /// In the context of the Mockaffee package, it is primarily used to map a
    /// function call to a sha1 value. Since the function call forms the unique key,
    /// sha1 is used to prevent collisions to a large extent and reduce the amount
    /// of storage capacity needed for the most keys.
    var sha1: String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        
        _ = self.withUnsafeBytes { bytes in
            CC_SHA1(bytes.baseAddress, CC_LONG(self.count), &digest)
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_SHA1_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
}
