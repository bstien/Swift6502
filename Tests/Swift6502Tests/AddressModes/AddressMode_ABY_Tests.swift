import XCTest
@testable import Swift6502
import Nimble

class AddressMode_ABY_Tests: XCTestCase {
    func test_simple_example() {
        let cpu = CPU.create(ram: [0xAA, 0xFF], yReg: 0x11)

        let extraClockCycles = cpu.setupAddressing(using: .aby)

        expect(cpu.addressAbsolute) == 0xFFBB
        expect(cpu.pc) == 0x02
        expect(extraClockCycles) == 0
    }

    func test_with_page_boundry_crossed() {
        let cpu = CPU.create(ram: [0xFF, 0x0E], yReg: 0x02)

        let extraClockCycles = cpu.setupAddressing(using: .aby)

        expect(cpu.addressAbsolute) == 0x0F01
        expect(cpu.pc) == 0x02
        expect(extraClockCycles) == 1
    }
}
