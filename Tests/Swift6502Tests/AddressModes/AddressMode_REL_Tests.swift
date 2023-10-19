import XCTest
@testable import Swift6502
import Nimble

class AddressMode_REL_Tests: XCTestCase {
    func test_with_positive_offset() {
        let cpu = CPU.create(ram: [0x03])

        cpu.setupAddressing(using: .rel)

        expect(cpu.addressRelative) == 0x0003
        expect(cpu.pc) == 0x01
    }

    func test_with_negative_offset() {
        let cpu = CPU.create(ram: [0xFE])

        cpu.setupAddressing(using: .rel)

        expect(cpu.addressRelative) == 0xFFFE
        expect(cpu.pc) == 0x01
    }
}
