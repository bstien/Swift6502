import XCTest
@testable import Swift6502
import Nimble

class AddressMode_IZX_Tests: XCTestCase {
    func test_simple_example() {
        let cpu = CPU.create(ram: [0x02, 0x00, 0x00, 0x00, 0xAA, 0xFF], xReg: 0x02)

        cpu.setupAddressing(using: .izx)

        expect(cpu.addressAbsolute) == 0xFFAA
        expect(cpu.pc) == 0x01
    }

    func test_it_wraps_around() {
        let cpu = CPU.create(ram: [0xFF, 0xAA, 0xFF], xReg: 0x02)

        cpu.setupAddressing(using: .izx)

        expect(cpu.addressAbsolute) == 0xFFAA
        expect(cpu.pc) == 0x01
    }
}
