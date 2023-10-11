import Foundation

extension Array where Element == UInt8 {
    func isWithinBounds(_ address: UInt16) -> Bool {
        indices.contains(Int(address))
    }

    static func createRam(using startData: [UInt8]) -> [UInt8] {
        startData + Array(repeating: 0x00, count: 0xFFFF + 1 - startData.count)
    }
}
