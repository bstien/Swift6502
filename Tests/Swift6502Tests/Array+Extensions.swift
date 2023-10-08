import Foundation

extension Array where Element == UInt8 {
    static func prepareForStack() -> [UInt8] {
        // The stack resides in the range 0x0100 to 0x1FF.
        // Return an array where the first page, 0x0000 to 0x00FF, is filled with zeroes.
        Array(repeating: 0x00, count: 0xFF + 1)
    }
}
