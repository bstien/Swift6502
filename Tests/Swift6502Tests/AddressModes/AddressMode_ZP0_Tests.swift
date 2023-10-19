import XCTest
@testable import Swift6502
import Nimble

class AddressMode_ZP0_Tests: XCTestCase {
    func test_simple_example() {
        let cpu = CPU.create(ram: [0xAA])

        cpu.setupAddressing(using: .zp0)

        expect(cpu.addressAbsolute) == 0xAA
        expect(cpu.pc) == 0x01
    }

    func test_extra_cycles() {
        let cpu = CPU.create(ram: [0xAA])

        let extraCycles = cpu.setupAddressing(using: .zp0)

        expect(extraCycles) == 0
    }
}
