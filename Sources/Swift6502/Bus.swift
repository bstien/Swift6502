import Foundation

class Bus {
    var ram: [UInt8]

    init(ram: [UInt8] = Array(repeating: UInt8(0x00), count: Int(UInt16.max))) {
        self.ram = ram
    }

    func read(_ address: UInt16) -> UInt8 {
        guard ram.indices.contains(Int(address)) else { return 0 }
        return ram[Int(address)]
    }

    func write(_ address: UInt16, data: UInt8) {
        guard ram.indices.contains(Int(address)) else { return }
        ram[Int(address)] = data
    }
}
