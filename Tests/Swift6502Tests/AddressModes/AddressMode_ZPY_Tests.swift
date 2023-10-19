import XCTest
@testable import Swift6502
import Nimble

class AddressMode_ZPY_Tests: XCTestCase {
    func test_simple_example() {
        let cpu = CPU.create(ram: [0xAA], yReg: 0x02)

        cpu.setupAddressing(using: .zpy)

        expect(cpu.addressAbsolute) == 0xAC
        expect(cpu.pc) == 1
    }

    func test_value_wraps_around() {
        let cpu = CPU.create(ram: [0xFF], yReg: 0x02)

        cpu.setupAddressing(using: .zpy)

        expect(cpu.addressAbsolute) == 0x01
        expect(cpu.pc) == 1
    }

    func test_no_extra_cycles_are_needed_for_wrap_around() {
        let cpu = CPU.create(ram: [0xFF], yReg: 0x02)

        let extraCycles = cpu.setupAddressing(using: .zpy)

        expect(extraCycles) == 0
    }
}
