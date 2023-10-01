import Foundation

class Bus {
    var ram = Array(repeating: UInt8(0x00), count: Int(UInt16.max))

    func read(_ address: UInt16) -> UInt8 {
        ram[Int(address)]
    }

    func write(_ address: UInt16, data: UInt8) {
        ram[Int(address)] = data
    }
}
