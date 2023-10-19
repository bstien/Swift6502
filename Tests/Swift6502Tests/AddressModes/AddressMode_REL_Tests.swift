import XCTest
@testable import Swift6502
import Nimble

class AddressMode_REL_Tests: XCTestCase {
    func test_with_positive_offset() {
        let cpu = CPU.create(ram: [0x03])

        cpu.setupAddressing(using: .rel)

        expect(cpu.addressAbsolute) == 0x0004
        expect(cpu.pc) == 0x01
    }

    func test_with_negative_offset() {
        let cpu = CPU.create(ram: [0x80])

        cpu.setupAddressing(using: .rel)

        expect(cpu.addressAbsolute) == 0xFF81
        expect(cpu.pc) == 0x01
    }
}
