import XCTest
@testable import Swift6502
import Nimble

class TSX_Tests: XCTestCase {
    func test_it_transfers_the_stack_pointer() {
        let cpu = CPU.create(ram: [], stackPointer: 0xAA)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .tsx, addressMode: .imp)

        expect(cpu.xReg) == 0xAA
    }

    func test_it_sets_zero_flag() {
        let cpu = CPU.create(ram: [], stackPointer: 0x00)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .tsx, addressMode: .imp)

        expect(cpu.xReg) == 0x00
        expect(cpu.readFlag(.zero)) == true
        expect(cpu.readFlag(.negative)) == false
    }

    func test_it_sets_negative_flag() {
        let cpu = CPU.create(ram: [], stackPointer: 0xFF)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .tsx, addressMode: .imp)

        expect(cpu.xReg) == 0xFF
        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.negative)) == true
    }
}
