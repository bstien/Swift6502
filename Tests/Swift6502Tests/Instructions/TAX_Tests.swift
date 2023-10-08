import XCTest
@testable import Swift6502
import Nimble

class TAX_Tests: XCTestCase {
    func test_it_stores() {
        let cpu = CPU.create(ram: [], acc: 0xFF)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .tax, addressMode: .imp)

        expect(cpu.xReg) == 0xFF
    }

    func test_it_sets_zero_flag() {
        let cpu = CPU.create(ram: [], acc: 0x00)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .tax, addressMode: .imp)

        expect(cpu.xReg) == 0x00
        expect(cpu.readFlag(.zero)) == true
        expect(cpu.readFlag(.negative)) == false
    }

    func test_it_sets_negative_flag() {
        let cpu = CPU.create(ram: [], acc: 0x80)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .tax, addressMode: .imp)

        expect(cpu.xReg) == 0x80
        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.negative)) == true
    }
}
