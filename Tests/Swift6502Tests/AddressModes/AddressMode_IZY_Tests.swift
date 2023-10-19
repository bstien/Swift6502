import XCTest
@testable import Swift6502
import Nimble

class AddressMode_IZY_Tests: XCTestCase {
    func test_simple_example() {
        let cpu = CPU.create(ram: [0x02, 0x00, 0xAA, 0xBB], yReg: 0x02)

        let extraClockCycles = cpu.setupAddressing(using: .izy)

        expect(cpu.addressAbsolute) == 0xBBAC
        expect(cpu.pc) == 0x01
        expect(extraClockCycles) == 0
    }

    func test_izy_with_page_boundry_crossed() {
        let cpu = CPU.create(ram: [0x02, 0x00, 0xFF, 0xBB], yReg: 0x01)

        let extraClockCycles = cpu.setupAddressing(using: .izy)

        expect(cpu.addressAbsolute) == 0xBC00
        expect(cpu.pc) == 0x01
        expect(extraClockCycles) == 1
    }
}
