import Foundation

extension Array where Element == UInt8 {
    static func prepareForStack(startData: [UInt8] = []) -> [UInt8] {
        // The stack resides in the range 0x0100 to 0x1FF.
        // Return an array where the first page, 0x0000 to 0x00FF, is filled with zeroes.
        return startData + Array(repeating: 0x00, count: 0xFF + 1 - startData.count)
    }

    static func createRam(using values: [UInt16: UInt8]) -> [UInt8] {
        var ram = Array(repeating: 0x00, count: 0xFFFF + 1)

        values.forEach { address, value in
            ram[Int(address)] = value
        }

        return ram
    }
}
